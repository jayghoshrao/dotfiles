#!/usr/bin/python3

## TODO: case insensitivity by default. Probably have to use re
## TODO: half match?
## TODO: Doesn't work when run from home dir

from pathlib import Path
import argparse
from pyfzf.pyfzf import FzfPrompt

fzf = FzfPrompt()
FZF_FILE_OPTS =  '--cycle -1 --bind="ctrl-x:execute@xdg-open {}@","ctrl-o:execute@nohup okular {} >/dev/null 2>&1 & disown@" --bind="ctrl-y:execute@echo {} | xclip -i -selection clipboard@"'

def find_up(name, startdir='.', stopdir='~', multiple=False, norecurse=False, nobreak=False):
    path = Path(startdir).resolve()                   ## start searching in startdir
    stop = Path(stopdir).expanduser().parent.resolve()   ## search in the stopdir, but not beyond. stopdir is inclusive
    res_nobreak = []
    res=[]
    while path != stop:
        if norecurse:
            res = [ x for x in path.glob(name) ]
        else:
            res = [ x for x in path.rglob(name) ]
        if nobreak:
            res_nobreak.extend(res)
        else:
            if res:
                if multiple:
                    return res
                else:
                    return [res[0]]
        path = path.parent
    return list(set(res_nobreak))


ap = argparse.ArgumentParser()
ap.add_argument("--start", default='.', help="Start directory for upward searching")
ap.add_argument("--stop", default='~', help="Stop directory for upward searching")
ap.add_argument("-m", "--multi", action='store_true', help="Flag to output all results at the first level with results instead of only the first encountered result.")
ap.add_argument("-x", "--no-break", action='store_true', default=False, help="Don't break loop on find. Continue till stopdir.")
ap.add_argument("-nr", "--no-recurse", action='store_true', default=False, help="Flag to avoid finding recursively.")
ap.add_argument("query", help="Search query/filename.")
args = vars(ap.parse_args())

found = find_up(args['query'], startdir=args['start'], stopdir=args['stop'], multiple=args['multi'], norecurse=args['no_recurse'], nobreak=args['no_break'])
# found = find_up_recursive(args['query'], multiple=args['multi'])

try:
    selected_file = fzf.prompt(found, FZF_FILE_OPTS)[0]
    print(selected_file)
except:
    pass

