#!/bin/bash

TIME=300

while true ; do

    info=$(acpi -b | awk -F'[,:%]' '{print $2, $3}')
    status=$(echo "$info" | awk '{print $1}')
    capacity=$(echo "$info" | awk '{print $2}')

	if [ "$status" = Discharging ] && [ "$capacity" -lt 10 ]; then
		i3-msg fullscreen disable
		notify-send -u critical -t 0 "Battery Critical!"
		TIME=30
	elif [ "$status" = Discharging ] && [ "$capacity" -lt 20  ]; then
		i3-msg fullscreen disable
		notify-send "Battery Low"
		TIME=180
	elif [ "$status" = Charging ] && [ "$capacity" -gt 20  ]; then
		TIME=300
	elif [ "$status" = Charging ] && [ "$capacity" -gt 50  ]; then
		TIME=600
	fi

sleep $TIME

done

