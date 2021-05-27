#!/usr/bin/env bash

function server_usage()
{
    usage=$(ssh "$1" ps -A -o %cpu | awk '{s+=$1} END {print s}')
    echo "$1: $usage"
}

servers=(ibt012 ibt013 ibt014 ibt067 ibt068 ibt069)
for srv in "${servers[@]}"
do
    server_usage $srv 
done
