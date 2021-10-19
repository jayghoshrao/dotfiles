#!/usr/bin/env sh
# streamlink -p "mpv --no-audio --wid=$2" "$1" best
# streamlink -p "mpv --hwdec=vaapi --wid=$2" "$1" best
eval "mpv --volume=50 --hwdec=vaapi --wid=$2 $1"
# eval "mpv --wid=$2 $1"
