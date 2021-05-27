#!/bin/bash
#
# z3bra -- 2014-01-21

if [[ $# != 2 ]]; then
    echo "Insufficient arguments."
    exit 1
fi

W3MIMGDISPLAY="/usr/lib/w3m/w3mimgdisplay"
FILENAME="${2}"
FONTH=14 # Size of one terminal row
FONTW=8  # Size of one terminal column
COLUMNS=`tput cols`
LINES=`tput lines`

read width height <<< `echo -e "5;$FILENAME" | $W3MIMGDISPLAY`
max_width=$(($FONTW * $COLUMNS))
max_height=$(($FONTH * $(($LINES - 2)))) # substract one line for prompt
if test $width -gt $max_width; then
    height=$(($height * $max_width / $width))
    width=$max_width
fi
if test $height -gt $max_height; then
    width=$(($width * $max_height / $height))
    height=$max_height
fi
while getopts ":c:d" COMMAND;
do
    case ${COMMAND} in
        c) w3m_command="6;0;0;$width;$height;\n4;\n3;"
            ;; # Clear image
        d) w3m_command="0;1;0;0;$width;$height;;;;;$FILENAME\n4;\n3;"
            ;; # Draw image
    esac
done
tput cup $(($height/$FONTH)) 0
echo -e $w3m_command|$W3MIMGDISPLAY
