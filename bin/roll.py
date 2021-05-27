#!/usr/bin/env python3

import sys
from random import seed, randint
# from rich import print
from rich.console import Console
from rich.text import Text
import argparse

def rollwrap(string):
    string = string.split(';')[0]
    for item in string.split('|'):
        rollstr = Text(item)
        rollstr.stylize(0, 20, "bold white")
        rollval = roll(str(rollstr))
        if args['silent']:
            print(rollval)
        else:
            console.print(rollstr + ":", rollval, style="bold white")

def roll(string):
    if ';' in string:
        splitstring=string.split(';')
        return roll(splitstring[0])
    elif string.strip() == '':
        return 0
    elif string.strip()[0] == '+':
        return roll('1d20' + string.strip())
    elif string.strip()[0] == '-':
        return roll('1d20' + string.strip())
    elif '+' in string:
        rollsum = 0
        splitstring = string.split('+')
        for item in splitstring:
            rollsum = rollsum + roll(item.strip())
        return rollsum
    elif '/' in string:
        splitstring = string.split('/')
        return roll(splitstring[0])/roll(splitstring[1])
    elif '*' in string:
        splitstring = string.split('*')
        return roll(splitstring[0])*roll(splitstring[1])
    elif '-' in string:
        splitstring = string.split('-')
        return roll(splitstring[0]) - roll(splitstring[1])
    else:
        try:
            if(string[0] == 'a'):
                console.print("Rolling with Advantage!", style="bold blue")
                r1 = roll_nds(string[1:])
                r2 = roll_nds(string[1:])
                return max(r1, r2)
            elif(string[0] == 'z'):
                console.print("Rolling with Disadvantage!", style="bold blue")
                r1 = roll_nds(string[1:])
                r2 = roll_nds(string[1:])
                return min(r1, r2)
            else:
                return roll_nds(string)
        except:
            print("Something is wrong. Rolling 0.")
            return 0

def roll_nds(string):
    if 'd' in string:
        try:
            n = int(string.split('d')[0])
        except:
            n = 1
        s = int(string.split('d')[1])
        rolls = [ randint(1,s) for i in range(n)]
        maxrolls = [s for i in range(n)]

        # NOTE: Only applies on multiple dice when EVERY hit is critical.
        # But since advantage and disadvantage are rolled as two separate dice
        # we can see crits and fumbles on ad20 and zd20, just not on 5d20
        if not args['silent']:
            if (maxrolls == rolls):
                console.print("CRITICAL ROLL!", style="bold yellow")
            elif (rolls == [1]*n):
                console.print("FUMBLED ROLL!", style="bold red")

        return (sum(rolls))
    else:
        try:
            return int(string)
        except:
            return 0

seed(a=None, version=2)
console = Console()
# rollstr = Text(''.join(sys.argv[1:]))
# rollstr.stylize(0, 20, "bold white")
# console.print(rollstr + ":", roll(str(rollstr)), style="bold white")

ap = argparse.ArgumentParser()
ap.add_argument("-s", "--silent", action='store_true', default=False, help="Only print output.")
ap.add_argument("input", nargs='*', help="input data")
args = vars(ap.parse_args())

if __name__ == "__main__":
    rollwrap(''.join(args['input']))
