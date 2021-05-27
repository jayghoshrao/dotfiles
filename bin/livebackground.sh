#!/usr/bin/env sh
# xwinwrap -fs -fdt -ni -b -nf -- livestream.sh WID
# xwinwrap -g 2880x1620 -ov -s -ni -b -nf -- livestream.sh WID

# xwinwrap -g 2880x1620 -ov -s -ni -b -nf -- livestream.sh "$1" WID


# resolution=$(xrandr -q | grep -E "primary" | awk '{print $4}' | cut -f1 -d '+')
resolution=$(xrandr -q | grep -E "primary" | awk '{print $4}')
xwinwrap -g $resolution -ov -s -ni -b -nf -- livestream.sh "$1" WID
