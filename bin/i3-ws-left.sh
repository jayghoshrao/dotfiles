#/usr/bin/env bash

CURRENT=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num')

for i in $(seq $((CURRENT-1)) -1 1); do
    if ! i3-msg -t get_workspaces | jq -e ".[].num | select(. == $i)" > /dev/null 2>&1; then
        i3-msg workspace $i
        exit 0
    fi
done

# No gaps found, create below minimum
MIN=$(i3-msg -t get_workspaces | jq '[.[].num | select(. != -1)] | min')
i3-msg workspace $((MIN - 1))
