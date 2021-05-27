#!/usr/bin/env dash

termite -e ranger --choosefile=/tmp/muttattach
cat > "$(cat /tmp/muttattach)"
