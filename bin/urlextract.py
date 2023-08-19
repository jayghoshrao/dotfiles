#!/usr/bin/python3

"""
@file: urlextract.py
@desc: fzf-based replacement for urlview/urlscan.

@input: text via pipe
@BROWSER: firefox --new-tab

"""

import re
import sys
from pyfzf.pyfzf import FzfPrompt
from subprocess import run, PIPE, Popen
import argparse

fzf = FzfPrompt()

FZF_URL_OPTS =  '--multi --tac --prompt="[ <C-u>: urler.sh | <C-y>: yank | <C-x>: xdg-open | <enter> ff ] Type to fuzzy match: " --bind="ctrl-x:execute@xdg-open {}@","ctrl-u:execute@nohup urler.sh {} >/dev/null 2>&1 & disown@" --bind="ctrl-y:execute@echo {} | xclip -i -selection clipboard@"'

## Extracted from urlview manpage
## This is not suited for mutt's usecase since messages may mess with whitespace. 
## So we would get hits for cases like "https://some-url.com/).NEXTWORDNOTINURL"
## NOTE: URLSCAN is better at this!! extract regex from there
urlregex=r'(((http|https|ftp|gopher)|mailto):(//)?[^ <>"\t]*|(www|ftp)[0-9]?\.[-a-z0-9.]+)[^ .,;\t\n\r<">\):]?[^, <>"\t]*[^ .,;\t\n\r<">\):]'

ap = argparse.ArgumentParser()
ap.add_argument("files", nargs='*', help="Input files with text and links.")
# ap.add_argument("-f", "--firefox", required=False, action='store_true', help="Open selected links in firefox tabs.")
ap.add_argument("-p", "--print", required=False, action='store_true', help="Print selected links to STDOUT.")
ap.add_argument("-r", "--run", default="firefox --new-tab", help="Command to open selected links.")
ap.add_argument("--pipe", action='store_true', help="Pipe links to run command instead of using as arguments")
args = vars(ap.parse_args())

text = sys.stdin.read().strip()

pattern = re.compile(urlregex)
links = [ match.group(0) for match in pattern.finditer(text, re.S) ]
links = [ x.replace('\n', '') for x in links ] ## for split links
links = list(dict.fromkeys(links))

try:
    selected_links = fzf.prompt(links, FZF_URL_OPTS)
    CMD = args['run'].split()
    if not args['pipe']:
        CMD.extend(selected_links)
        run(CMD)
    else:
        # raise NotImplementedError
        echo = ['echo'] + selected_links
        p1 = Popen(['echo'] + selected_links, stdout=PIPE)
        p2 = Popen(CMD, stdin=p1.stdout, shell=True)
        p2.communicate()
except:
    pass

