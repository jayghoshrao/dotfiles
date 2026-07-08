#!/usr/bin/env bash

"""
Snip and download as mp4 a portion of the given youtube video.

usage: ./yt-dlp-slice.sh <link> <start-time> <duration> <output-file>

"""

STREAMS=$(yt-dlp -g $1)

readarray -t y <<<"$STREAMS"

ffmpeg -f mp4 -ss $2 -i "${y[0]}" -ss $2 -i "${y[1]}" -t $3 -map 0:v -map 1:a -c:v libx264 -c:a aac $4
