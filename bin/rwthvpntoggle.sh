#!/usr/bin/env zsh

STATUS=$(nmcli con | grep -i 'RWTH Aachen' | awk '{print $NF}')

if [[ "$STATUS" == "--" ]]; then
    nmcli con up 'RWTH Aachen'
else
    nmcli con down 'RWTH Aachen'
fi
