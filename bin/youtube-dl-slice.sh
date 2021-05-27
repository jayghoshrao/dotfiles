#!/usr/bin/env bash

"""
Snip and download as mp4 a portion of the given youtube video.

usage: ./youtube-dl-ranged.sh <link> <start-time> <duration> <output-file>

"""

STREAMS=$(youtube-dl -g $1)

readarray -t y <<<"$STREAMS"

ffmpeg -f mp4 -ss $2 -i "${y[0]}" -ss $2 -i "${y[1]}" -t $3 -map 0:v -map 1:a -c:v libx264 -c:a aac $4
