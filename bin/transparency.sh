#!/bin/bash

WINDOWS=$(xprop -root _NET_CLIENT_LIST | cut -d'#' -f2 | tr -d ',')

for WINDOW in $WINDOWS
do
	transset-df -t 0 -i $WINDOW
done
