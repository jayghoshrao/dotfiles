#!/usr/bin/env python3

import ctypes
import ctypes.util
import os
import sys
import argparse
from pathlib import Path
import pwd

from iterfzf import iterfzf

## TODO: Properly manage blkid cache. Get and put, use single (global?) cache.
## TODO: Reconsider design: Pure python-c binding library? Or utilities? No official bindings exist.
## SETUID etc: https://engineering.purdue.edu/ECN/Support/KB/Docs/HowToSUIDSGIDscripts
## - Might as well rewrite in C/C++ to avoid wrapping script and run the C/C++ binary automatically.
## - essentially create a modern pmount. Maybe even consider using rust (with skim)?
## https://blog.lxsang.me/post/id/28.0
# The reason for keeping it in python is for import in mirror.
# and easy access to fzf modules
# https://www.gnu.org/software/libc/manual/html_node/Setuid-Program-Example.html

DEFAULT_MOUNT_ROOT = Path('/media')

libc = ctypes.CDLL(ctypes.util.find_library('c'), use_errno=True)
libblkid = ctypes.CDLL(ctypes.util.find_library('blkid'), use_errno=True)

libc.mount.argtypes = (ctypes.c_char_p, ctypes.c_char_p, ctypes.c_char_p, ctypes.c_ulong, ctypes.c_char_p)
libc.mount.restype = ctypes.c_int

libc.umount.argtypes = (ctypes.c_char_p,)
libc.umount.restype = ctypes.c_int

# libc.umount2.argtypes = (ctypes.c_char_p, ctypes.c_int)
# libc.umount2.restype = ctypes.c_int

# Define necessary structures
class StructListHead(ctypes.Structure):
    pass

StructListHead._fields_ = [
    ('next', ctypes.POINTER(StructListHead)),
    ('prev', ctypes.POINTER(StructListHead)),
]

class StructBlkidCache(ctypes.Structure):
    _fields_ = [
        ('_unused', ctypes.c_int) 
    ]

class StructBlkidStructDev(ctypes.Structure):
    _fields_ = [
        ('bid_devs', StructListHead),
        ('bid_tags', StructListHead),
        ('bid_cache', ctypes.POINTER(StructBlkidCache)),
        ('bid_name', ctypes.c_char_p),
        ('bid_xname', ctypes.c_char_p),
        ('bid_type', ctypes.c_char_p),
        ('bid_pri', ctypes.c_int),
        ('bid_devno', ctypes.c_ulonglong),  # Assuming dev_t is unsigned long long
        ('bid_time', ctypes.c_long),
        ('bid_utime', ctypes.c_long),
        ('bid_flags', ctypes.c_uint),
        ('bid_label', ctypes.c_char_p),
        ('bid_uuid', ctypes.c_char_p),
    ]

    def __repr__(self):
        str = f"{self.bid_name.decode()}" 
        str += f" \"{self.bid_label.decode()}\"" if self.bid_label else ' -'
        str += f" {self.bid_uuid.decode()}"
        str += f" ({self.bid_type.decode()})"
        str += f" --> {get_mountpoint(self.bid_name.decode())}" if is_disk_mounted(self.bid_name.decode()) else ''
        return str


blkid_dev_iterate_begin = libblkid.blkid_dev_iterate_begin
blkid_dev_iterate_begin.restype = ctypes.POINTER(StructBlkidStructDev)
blkid_dev_iterate_begin.argtypes = [ctypes.POINTER(StructBlkidCache)]

blkid_dev_iterate_end = libblkid.blkid_dev_iterate_end
blkid_dev_iterate_end.restype = None
blkid_dev_iterate_end.argtypes = [ctypes.POINTER(StructBlkidStructDev)]

blkid_dev_next = libblkid.blkid_dev_next
blkid_dev_next.restype = ctypes.c_int
blkid_dev_next.argtypes = [ctypes.POINTER(StructBlkidStructDev), ctypes.POINTER(ctypes.POINTER(StructBlkidStructDev))]

blkid_get_cache = libblkid.blkid_get_cache
blkid_get_cache.restype = ctypes.c_int
blkid_get_cache.argtypes = [ctypes.POINTER(ctypes.POINTER(StructBlkidCache)), ctypes.c_void_p]

blkid_put_cache = libblkid.blkid_put_cache
blkid_put_cache.argtypes = [ctypes.c_void_p]
blkid_put_cache.restype = None

blkid_get_tag_value = libblkid.blkid_get_tag_value
blkid_get_tag_value.argtypes = [ctypes.c_int, ctypes.c_char_p, ctypes.c_char_p]
blkid_get_tag_value.restype = ctypes.c_char_p

blkid_evaluate_tag = libblkid.blkid_evaluate_tag
blkid_evaluate_tag.argtypes = [ctypes.c_char_p, ctypes.c_char_p, ctypes.c_void_p]
blkid_evaluate_tag.restype = ctypes.c_char_p

blkid_probe_all = libblkid.blkid_probe_all
blkid_probe_all.argtypes = [ctypes.c_void_p]
blkid_probe_all.restype = ctypes.c_int

def mount(source, target=None, options=0, data=None):
    if not source:
        cache = ctypes.POINTER(StructBlkidCache)()
        ret = blkid_get_cache(ctypes.byref(cache), 0)
        if ret != 0:
            raise RuntimeError(f"Failed to get blkid cache")

        devnames = [dev.bid_name.decode('utf-8') for dev in iterate_over_devices(8) if not is_disk_mounted(dev.bid_name.decode('utf-8'))]
        source = iterfzf(devnames)

    if not source:
        return

    if not target:
        target = (DEFAULT_MOUNT_ROOT / os.path.basename(source)).as_posix()

    Path(target).mkdir(exist_ok=True)
    fs = get_fstype(source)

    if fs == 'ntfs':
        fs = 'ntfs3' # use ntfs3 kernel driver
    elif fs == 'exfat' or fs == 'vfat':
        # Mount exfat with uid,gid set
        if os.getuid() == 0 and os.environ.get('SUDO_USER', None):
            pwd_entry = pwd.getpwnam(os.getlogin())
            if not data:
                data=f"uid={pwd_entry.pw_uid},gid={pwd_entry.pw_gid}"

    ret = libc.mount(source.encode(), target.encode(), fs.encode(), options, data.encode() if data else None)
    if ret < 0:
        errno = ctypes.get_errno()
        print(f"uid={os.getuid()} gid={os.getgid()}")
        raise OSError(errno, f"Error mounting {source} ({fs}) on {target} with options {options}, data {data}: {os.strerror(errno)}")

    return target

def umount(target):
    if not target:
        mounted_devnames = [dev.bid_name.decode('utf-8') for dev in iterate_over_devices(8) if is_disk_mounted(dev.bid_name.decode('utf-8'))]
        mountpoints = [get_mountpoint(devname) for devname in mounted_devnames]
        targets = iterfzf(mountpoints, multi=True)
    else:
        targets = [target]

    if not targets:
        return

    for target in targets:
        ret = libc.umount(target.encode())
        if ret < 0:
            errno = ctypes.get_errno()
            raise OSError(errno, f"Error unmounting {target}: {os.strerror(errno)}")

def umount2(target, flags):
    """ Allows forceful unmounting with flags=1"""
    ret = libc.umount2(target.encode(), flags)
    if ret < 0:
        errno = ctypes.get_errno()
        raise OSError(errno, f"Error unmounting {target} with flags {flags}: {os.strerror(errno)}")

def is_disk_mounted(disk):
    with open('/proc/mounts', 'r') as f:
        mounts = f.readlines()
    for mount in mounts:
        if mount.startswith(disk):
            return True
    return False

def get_mountpoint(disk):
    with open('/proc/mounts', 'r') as f:
        mounts = f.readlines()
    for mount in mounts:
        if mount.startswith(disk):
            return mount.split()[1]
    return ''

def get_fstype(disk):
    cache = get_blkid_cache()
    blkid_probe_all(cache)
    fstype = blkid_get_tag_value(cache._fields_['_unused'], b'TYPE', disk.encode())
    if fstype is not None:
        return fstype.decode()
    raise ValueError(f"Could not determine filesystem type for {disk}")

def find_disk_by_uuid(uuid):
    devname = blkid_evaluate_tag(b'UUID', uuid.encode(), 0)
    if devname:
        return devname.decode()
    return ''


def major(devno):
    return (devno >> 8) & 0xff

# Python function to iterate over all devices
def iterate_over_devices(devno=None):
    cache = get_blkid_cache()
    blkid_probe_all(cache)
    iter_handle = blkid_dev_iterate_begin(cache)
    if not iter_handle:
        raise RuntimeError("Failed to begin device iteration")

    try:
        while True:
            ret_dev = ctypes.POINTER(StructBlkidStructDev)()
            ret = blkid_dev_next(iter_handle, ctypes.byref(ret_dev))
            if ret != 0:
                break

            if devno:
                if major(ret_dev.contents.bid_devno) == devno:
                    yield ret_dev.contents
            else:
                yield ret_dev.contents
    finally:
        blkid_dev_iterate_end(iter_handle)

def get_blkid_cache():
    cache = ctypes.POINTER(StructBlkidCache)()
    ret = blkid_get_cache(ctypes.byref(cache), 0)
    if ret != 0:
        raise RuntimeError(f"Failed to get blkid cache")
    return cache

def parse_args():
    ap = argparse.ArgumentParser()
    subparsers = ap.add_subparsers(dest='mode')

    sub_list = subparsers.add_parser('list', help='list device, label, fstype, and mount directory for each device')

    sub_mount= subparsers.add_parser('mount', help='mount device')
    sub_mount.add_argument('device', nargs='?', help="device to mount")
    sub_mount.add_argument('target', nargs='?', help="target directory")
    sub_mount.add_argument('-o', '--options', help='Options to pass while mounting (NOT mountflags)')

    sub_unmount= subparsers.add_parser('unmount', help='unmount device')
    sub_unmount.add_argument('target', nargs='?', help="target dir to unmount")

    sub_fstype = subparsers.add_parser('fstype', help='find fstype of device')
    sub_fstype.add_argument('device', help="device to mount")

    sub_uuid = subparsers.add_parser('uuid', help='find name of device given uuid')
    sub_uuid.add_argument('uuid', help='UUID of disk')

    return ap.parse_args()


def main():
    args = parse_args()

    print(args)

    if args.mode == 'mount':
        mount(args.device, args.target, 0, args.options)
    elif args.mode == 'unmount':
        umount(args.target)
    elif args.mode == 'list':
        for dev in iterate_over_devices(8):
            print(dev)
    elif args.mode == 'fstype':
        print(get_fstype(args.device))
    elif args.mode == 'uuid':
        devname = find_disk_by_uuid(args.uuid)
        print(devname)
        if not devname:
            sys.exit(-1)
    else:
        raise ValueError(args.mode)

if __name__ == "__main__":
    main()
