#/usr/bin/env bash
 
CURRENT=$(i3-msg -t get_workspaces | jq '.[] | select(.focused==true).num')

# Find the maximum workspace number
MAX=$(i3-msg -t get_workspaces | jq '[.[].num | select(. != -1)] | max')

# Search for gaps between current and max
for i in $(seq $((CURRENT+1)) $MAX); do
    if ! i3-msg -t get_workspaces | jq -e ".[].num | select(. == $i)" > /dev/null 2>&1; then
        i3-msg workspace $i
        exit 0
    fi
done

# No gaps found, create above maximum
i3-msg workspace $((MAX + 1))
