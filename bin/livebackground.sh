#!/usr/bin/env sh
# xwinwrap -fs -fdt -ni -b -nf -- livestream.sh WID
# xwinwrap -g 2880x1620 -ov -s -ni -b -nf -- livestream.sh WID

# xwinwrap -g 2880x1620 -ov -s -ni -b -nf -- livestream.sh "$1" WID


# resolution=$(xrandr -q | grep -E "primary" | awk '{print $4}' | cut -f1 -d '+')
# resolution=$(xrandr -q | grep -E "primary" | awk '{print $4}')
# resolution="2304x1296+3610+360"

resolution=$(xrandr --listactivemonitors | tail -n+2 | awk '{print $2, $3}' | sed 's|/[0-9]\+x|x|;s|/[0-9]\++|+|' | fzf | awk '{print $2}')
xwinwrap -g $resolution -ov -s -ni -b -nf -- livestream.sh "$1" WID
