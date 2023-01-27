#!/bin/bash

# DONE: if directory, LS, if file, whatever

KEY=$1
FILE_EXT=$2
# FILE_EXT=$(echo "$FILE_EXT" | cut -f1 -d"	")
EXT=${FILE_EXT##*.}
FILETYPE="$(file --mime-type "$FILE_EXT" | awk '{print $NF}')"

GREPPRG=grep

# if hash rg 2>/dev/null; then
# 	GREPPRG=rg
# fi

if [ -d "$FILE_EXT" ]; then 
    ls -p --color=always --group-directories-first "$FILE_EXT"
elif [[ "$FILETYPE" == *"directory"*  ]]; then
    ls -p --color=always --group-directories-first "$FILE_EXT"
elif [ "$EXT" = "pdf" ]; then
	v=$(echo "$KEY" | tr " " "|")
	echo {$FILE_EXT} | "$GREPPRG" -E "^|$v" -i --color=always
	pdftotext -f 1 -l 1 "$FILE_EXT" - | fold -w 80 -s | "$GREPPRG" -E "^|$v" -i --color=always 
elif [[ "$FILETYPE" == *"text"*  ]]; then
	fold -w 80 -s "$FILE_EXT" 
elif [[ "$FILETYPE" == *"image"*  ]]; then
    # termplay "$FILE_EXT"
    # img.sh -d "$FILE_EXT"
    echo "$FILE_EXT"
    echo "Image preview not supported."
else
    echo "$FILETYPE"
    echo "Preview not supported."
	# cat "$FILE_EXT"
fi
