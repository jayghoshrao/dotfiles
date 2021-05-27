#!/bin/python3

# depends on the mplstyle files from https://github.com/garrettj403/SciencePlots
# Usage: ./plotChrom.py <file> <file>
# Output: plot.pdf and plot.jpg

# DONE: argparse support for xlabel, ylabel and title
# TODO: argparse support for plt.show
# DONE: argparse support for delimiter

import matplotlib.pyplot as plt
# import csv
import sys
import argparse

def readCSV(data_path):
    time= []
    conc= []
    with open(data_path, newline='') as csvfile:
        # data = list(csv.reader(csvfile))
        for line in csvfile:
            data_line = line.strip().split(',')
            data_line = list(filter(None, data_line))
            if (data_line != []):
                time.append(float(data_line[0]))
                conc.append(float(data_line[1]))
    return time, conc

def readCadet(infile, unit, solution='outlet'):
    from cadet import Cadet
    from addict import Dict

    cadetpath = "/home/jayghoshter/local/bin/cadet-cli"
    Cadet.cadet_path = cadetpath
    sim = Cadet()
    sim.filename = infile
    sim.load()
    x = sim.root.output.solution.solution_times
    y = sim.root.output.solution['unit_' + "%03d" % unit]['solution_' + solution]

    return x, y

def normalize(data):
    return [ x/data[-1] for x in data ]

def readfile(data_path, sep, columns):
    x = []
    y = []
    xticksFromFile= None
    xticks = []
    # columns = [0, 1]
    with open(data_path, newline='') as infile:
        # data = list(csv.reader(infile))
        for line in infile:
            data_line = line.strip().split(sep)
            data_line = list(filter(None, data_line))
            if (data_line != []):
                if columns[0] != -1:
                    x.append(float(data_line[columns[0]]))
                y.append(float(data_line[columns[1]]))
                if xticksFromFile:
                    xticks.append(float(data_line[columns[xticksFromFile]]))

    return x, y, xticks

ap = argparse.ArgumentParser()
ap.add_argument("files", nargs='*', help="files to plot")
ap.add_argument("-t", "--title", required=False,
        help="title")
ap.add_argument("-x", "--xlabel", required=False,
        help="xlabel")
ap.add_argument("-y", "--ylabel", required=False,
        help="ylabel")
ap.add_argument("-m", "--marker", required=False,
        help="ylabel")
ap.add_argument("-n", "--normalize", required=False, action='store_true',
        help="normalize y data to the last value")
ap.add_argument("-l", "--labels", required=False, nargs='*',
        help="legend labels")
ap.add_argument("-c", "--columns", required=False, nargs=2, default = [0,1], type = int,
        help="columns to plot as x, y. (Partially implemented)")
ap.add_argument("-o", "--output", required=True,
        help="output file")
ap.add_argument("-hg", "--histogram", type=int, required=False,
        help="histogram")
ap.add_argument("-s", "--separator", required=False, default=',', help="separator character")

ap.add_argument("--cadet", nargs=2, required=False)

args = vars(ap.parse_args())

# TODO: Implement fully
if not args['labels']:
    args['labels'] = args['files']

with plt.style.context(['science']):
    fig, ax = plt.subplots()
    xs = []
    ys = []
    lines = []
    count =0
    for arg in args['files']:
        if args['cadet']:
            x, y = readCadet(arg, int(args['cadet'][0]), args['cadet'][1])
            print(x,y)
        else:
            x, y, xticks = readfile(arg, args['separator'], args['columns'])
        if args['normalize']:
            y = normalize(y)
        if x != []:
            line = ax.plot(x, y, label=arg, marker=args['marker'])
        else:
            if args['histogram']:
                line = ax.hist(y, bins=args['histogram'])
            else:
                line = ax.plot(y, label=arg, marker=args['marker'])
        # xs.append(x)
        # ys.append(y)
        lines.append(line)
        count+=1
    legend = ax.legend(loc='best', shadow=True)
    ax.set(title=args['title'])
    ax.set(xlabel=args['xlabel'])
    ax.set(ylabel=args['ylabel'])
    ax.autoscale(tight=True)
    fig.savefig(args['output'])
    # fig.savefig('plot.jpg', dpi=300)

