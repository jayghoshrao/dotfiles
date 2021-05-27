#!/bin/bash

eval "$(date +'today=%F now=%s')"
midnight=$(date -d "$today 0" +%s)
nine=$(date -d "$today 9" +%s)
seventeen=$(date -d "$today 17" +%s)

# echo "$((now - midnight))"
# echo "$((now - nine))"
# echo "$((nine - midnight))"

# echo "$((now - nine))"
# echo "$((seventeen - nine))"
# echo "$(((now - nine)/2))"

PERCENT=$(( (now - nine)*100 / (seventeen - nine) ))

if [[ "$PERCENT" -lt 100 && "$PERCENT" -gt 0  ]]; then
	echo "$PERCENT"
elif [[ "$PERCENT" -gt 100 ]]; then
	echo "100"
else
	echo "0"
fi

