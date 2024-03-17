#!/usr/bin/env bash

STATUS=$(~/bin/pomodoro-client.py status)

[[ -n "$STATUS" ]] && row=1 || row=0 ;

ARG=$(echo -e "  start\n  toggle\n  pause\n  resume\n  stop" | rofi -theme-str 'window {width: 60ch;} listview { layout: horizontal; columns: 1; lines: 5; }' -dmenu -i -p Pomodoro -l 5 -selected-row $row | awk '{print $2}')
[ -n $ARG ] && ~/bin/pomodoro-client.py $ARG
