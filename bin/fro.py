#!/usr/bin/python3
import re
import sys
from pyfzf.pyfzf import FzfPrompt
from pathlib import Path
from random import seed, randint

## TODO: YAML header instead? or use + as prefix for options?
## TODO: Use indentation just like in roland


fzf = FzfPrompt()
seed(a=None, version=2)

FZF_FILE_OPTS =  '--cycle --bind="ctrl-x:execute@xdg-open {}@","ctrl-o:execute@nohup okular {} >/dev/null 2>&1 & disown@" --bind="ctrl-y:execute@echo {} | xclip -i -selection clipboard@"'

folder = Path('/home/jayghoshter/Repositories/dmtools/lists')
allfiles = sorted([x.name for x in folder.iterdir()])

def processFile(filename):
    datalist = []
    pick = 1

    with open(filename, 'r') as listfile:
        for line in listfile:
            if ':' in line:
                key = line.split(':')[0].strip()
                val = line.split(':')[1].strip()


                if key == 'pick':
                    pick = int(val)

                global pattern
                if key == 'type' and val == 'list':
                    pattern = re.compile(r"^\s+- ")
                elif key == 'dice':
                    print("Dice type not supported yet!")
                    """
                    Should look for \d\+: and read until the next line with that pattern
                    In that case, I shouldn't do this per line.
                    if: line has 'number:', append
                    else: append string to last element of list
                    """
                    raise NotImplementedError
            else:
                datalist.append(pattern.sub('', line).replace('\n', ''))

    for i in range(pick):
        print(datalist[randint(0,len(datalist)-1)])


selected_file = fzf.prompt(allfiles, FZF_FILE_OPTS)[0]
selected_full_file = folder / selected_file
processFile(selected_full_file)
