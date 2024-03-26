#!/usr/bin/env bash

# NOTE: Associative arrays need bash 4.0
declare -A SINK_ALIASES
SINK_ALIASES[alsa_output.pci-0000_00_1f.3.analog-stereo]="Speakers"
SINK_ALIASES[alsa_output.usb-Lenovo_ThinkPad_Thunderbolt_3_Dock_USB_Audio_000000000000-00.iec958-stereo]="Dock"
SINK_ALIASES[bluez_sink.00_16_94_28_96_DD.a2dp_sink]="HD 4.40BT"

SINKS_FOUND=$(pactl list short sinks | awk '{print $2}')

SINKS_FOUND_ALIASED=()
while IFS= read -r sink ; do
    SINKS_FOUND_ALIASED+=("${SINK_ALIASES[$sink]}")
done <<< "$SINKS_FOUND"

NCHARS=$(echo "${SINKS_FOUND_ALIASED[@]}" | wc -m)
ROFI_WIDTH=$(( NCHARS + 10 ))

selected_sink_aliased=$((IFS=$'\n'; echo "${SINKS_FOUND_ALIASED[*]}") | rofi -theme-str "window {width:${ROFI_WIDTH}ch;}" -theme nord-horizontal -dmenu -p Output -i -no-fixed-num-lines)

selected_sink=""
for sink in "${!SINK_ALIASES[@]}"; do
    if [[ "${SINK_ALIASES[$sink]}" == "$selected_sink_aliased" ]]; then
        selected_sink=$sink
    fi
done

pactl set-default-sink $selected_sink
