#!/bin/bash

# Display handling script. To be used in conjunction with "bin/savescreenlayout".
#

set -euo pipefail

run -d

# layoutsDir="$HOME/.screenlayout"
# layoutsFile="$layoutsDir/layouts"
# currentHash=$(xrandr --prop | grep -A2 EDID | sha256sum | cut -c 1-32)
# currentLayout=$(grep "$currentHash" "$layoutsFile" | awk '{print $1}')

# # ## Turn off everything except laptop monitor
# xrandr \
# --output eDP1 --primary --mode 2560x1440 --pos 0x0 --rotate normal \
# --output VIRTUAL1 --off  \
# --output DP1 --off  \
# --output HDMI2 --off  \
# --output HDMI1 --off  \
# --output DP1-3 --off  \
# --output DP1-2 --off  \
# --output DP1-1 --off  \
# --output DP2 --off \
# --output DP2-2 --off \
# --output DP2-3 --off 

# "$layoutsDir/${currentLayout}.sh"
