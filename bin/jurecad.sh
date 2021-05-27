#!/bin/sh

## jureca daemon to notify locally when job status is changed

oldstat=$(ssh jureca 'squeue -u rao2 -h --format="%.18i %.9P %.4D %.15j %.2t"')
echo "Job Status [$(date)]"
echo "$oldstat"

while true; do
    newstat=$(ssh jureca 'squeue -u rao2 -h --format="%.18i %.9P %.4D %.15j %.2t"')
    if [ "$oldstat" != "$newstat" ]; then
        notify-send -t 0 Update "$newstat"
        ntfy send "$newstat"
        echo "Updated Job Status [$(date)]"
        echo "$newstat"
    fi
    oldstat="$newstat"
    sleep 60
done
