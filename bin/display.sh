#!/bin/bash

# Script to manage displays. [14 March 2019]

DISPLAYS=$(xrandr -q | grep -E " connected" | awk '{ print $1 }' | tr '\n' ';')
IFS=';' read -ra display <<< "$DISPLAYS"

CMD=""

## The first case might be required in case of a ghost screen on disconnect.
if [ "$DISPLAYS" == "eDP1;" ]; then
	CMD="xrandr --output VIRTUAL1 --off --output eDP1 --primary --mode 2560x1440 --pos 0x0 --rotate normal --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP1-3 --off --output DP1-2 --off --output DP1-1 --off --output DP2 --off --output DP2-3 --off"
    $CMD
elif [[ ${#display[@]} -gt 2 ]]; then
    # CMD="xrandr --output ${display[0]} --off --output ${display[1]} --scale 1.5x1.5 --auto --pos 0x0  "
    # $CMD
    # for (( i=2; i< ${#display[@]}; i++ )); do
    #     # CMD="$CMD""--output ""${display[$i]}"" --scale 1.5x1.5 --auto --right-of ""${display[$(( $i - 1 ))]}  "
    #     CMD="xrandr --output ""${display[$i]}"" --scale 1.5x1.5 --auto --right-of ""${display[$(( $i - 1 ))]}  "
    #     $CMD
    # done
    # CMD=""
    # $CMD
    xrandr --output VIRTUAL1 --off --output eDP1 --off --output DP1 --off --output HDMI2 --off --output HDMI1 --off --output DP1-3 --off --output DP1-2 --mode 1920x1200 --pos 2880x0 --rotate left --scale 1.5x1.5 --output DP1-1 --primary --mode 1920x1200 --pos 0x536 --rotate normal --scale 1.5x1.5 --output DP2 --off
else 
    CMD="xrandr --output eDP1 --primary --auto --pos 0x0 "
    for (( i=1; i< ${#display[@]}; i++ )); do
        CMD="$CMD""--output ""${display[$i]}"" --auto --right-of ""${display[$(( $i - 1 ))]} --scale 1.5x1.5 "
    done
    $CMD
fi

# $CMD
# ~/.fehbg
feh --bg-fill $HOME/Pictures/wallpapers/current-wall.png /home/jayghoshter/Pictures/wallpapers/*
