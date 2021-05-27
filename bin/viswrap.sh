#!/bin/bash

## Wrapper for vis.py -b to run in parallel

basefilename="test-case"
fileformat=".pvtu"
scalar="scalar_1"
num=3

set +m
for (( i=0; i<$num; i++ )); do
    filename="$basefilename"'_'"$i$fileformat" ; 
    vis.py "$filename" -b -c "$scalar" > /dev/null &
done
set -m
