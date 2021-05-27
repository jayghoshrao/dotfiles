#!/bin/bash

# [ -n "$@" ] && URLS="$@" || read -r URLS
if [[ -n "$@" ]]; then
    URLS="$@"
else
    read -r URLS
fi

urlregex='(https?|ftp|file)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]'

# echo "$URL"
for URL in ${URLS[@]}; do 
    [[ ! "$URL" =~ $urlregex ]] && >&2 echo "ERROR: Input is not a URL!" && exit

    case "$URL" in
        *mkv|*webm|*mp4|*youtube.com/watch*|*youtube.com/playlist*|*youtu.be*)
            setsid -f mpv --input-ipc-server=/tmp/mpvsoc"$(date +%s)" -quiet "$URL" & disown >/dev/null 2>&1 ;;
        *png|*jpg|*jpe|*jpeg|*gif)
            curl -sL "$URL" > "/tmp/$(echo "$URL" | sed "s/.*\///")" && sxiv -a "/tmp/$(echo "$URL" | sed "s/.*\///")"  >/dev/null 2>&1 & ;;
        *mp3|*flac|*opus|*mp3?source*)
            setsid -f mpv --save-position-on-quit --input-ipc-server=/tmp/mpvsoc"$(date +%s)" -quiet "$URL" & disown >/dev/null 2>&1 ;;
        *xkcd.com*)
            curl -sSL "$URL" | hq img attr src | grep comics | sed 's/^/https:/' | xargs feh -ZF ;;
        *)
            if [ -f "$URL" ]; then 
                "$TERMINAL" -e "$EDITOR $URL"
            else 
                setsid -f "$BROWSER" "$URL" >/dev/null 2>&1 
            fi ;;
    esac
done
