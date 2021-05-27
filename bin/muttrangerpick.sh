#!/usr/bin/env bash

tmpfile=/tmp/muttrangerpick
if \[ -z "$1" \]; then
   ranger --choosefiles $tmpfile && sed -i 's/ /\\ /g' $tmpfile && echo "$(awk 'BEGIN {printf "%s", "push "} {printf "%s", "<attach-file>"$0"<enter>"}'  $tmpfile)" > $tmpfile
elif \[ $1 == "clean" \]; then
  rm $tmpfile
fi
