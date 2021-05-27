#!/bin/bash

current=$HOME/.cache/current.layout
xrandr --prop | grep -A2 EDID > $current

# ## Turn off everything except laptop monitor
# xrandr -q | awk '/ connected / {print $1}' | while read display; do
#     [[ $display != "eDP1" ]] && xrandr --output $display --off || xrandr --output $display --auto
# done

# ## Turn off everything except laptop monitor
xrandr \
--output eDP1 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
--output VIRTUAL1 --off  \
--output DP1 --off  \
--output HDMI2 --off  \
--output HDMI1 --off  \
--output DP1-3 --off  \
--output DP1-2 --off  \
--output DP1-1 --off  \
--output DP2 --off \
--output DP2-2 --off \
--output DP2-3 --off 

for prelayout in $HOME/.screenlayout/*.layout; do
    cmp -s $prelayout $current && echo "Running ${prelayout%%.layout}.sh" && ${prelayout%%.layout}.sh 
done

run -w -p -c
