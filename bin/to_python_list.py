#!/usr/bin/env python3

import numpy as np
import argparse

try:
    from rich import print
except ImportError:
    pass

def main():
    ap = argparse.ArgumentParser()
    ap.add_argument('FILE', help='file with data to dump')
    ap.add_argument('-d', '--delimiter', nargs=1, default=',', help='file with data to dump')
    ap.add_argument('-c', '--columns', nargs='*', type=int, help='columns to print out')
    ap.add_argument('-lw', '--linewidth', type=int, help='numpy printoptions linewidth for wrapping')
    ap.add_argument('-p', '--precision', type=int, help='float print precision')
    args = ap.parse_args()

    data = np.loadtxt(args.FILE, delimiter=',').T

    columns = args.columns
    if args.columns is None:
        columns = np.arange(len(data))

    for col in columns:
        print(np.array2string(data[col], precision=args.precision, separator=', ', max_line_width=args.linewidth))


if __name__ == "__main__":
    main()
