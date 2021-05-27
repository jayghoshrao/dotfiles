#!/bin/sh

BOOKMARKS_FILE=~/.newsboat/bookmarks.txt

[ "$#" -eq 0 ] && exit 1
if [ -n $(command -v curl) ]; then
  url=$(curl -sIL -o /dev/null -w '%{url_effective}' "$1")
else  
  url="$1"
fi

# echo "$url"
url=$(echo "${url}" | perl -p -e 's/(\?|\&)?utm_[a-z]+=[^\&]+//g;' -e 's/(#|\&)?utm_[a-z]+=[^\&]+//g;')
title="$2"
description="$3"
sep=" | "

line="$title$sep$url"

grep -Pq "$line" "$BOOKMARKS_FILE" || echo -e "$line" >> "$BOOKMARKS_FILE"

# grep -Pq "${title}${sep}${description}" ~/.newsboat/bookmarks.txt || echo -e "${title}${sep}${description}${sep}${url}" >> ~/.newsboat/bookmarks.txt


# grep -q "${url}\t${title}\t${description}" ~/.newsboat/bookmarks.txt || echo -e "${url}\t${title}\t${description}" >> ~/.newsboat/bookmarks.txt
