#!/bin/env bash

## FETCH bibliography from metadata of pdf files
## Expects metadata to contain DOI
## Works on pdf files in current folder in parallel
## Avoids rate limiting by random (1-10s) sleep before the fetch

fetch(){

    FILENAME="$1"
    BIBFILE="ref.bib"
    echo "File: $1"
    [ -f "$1" ] || (echo "NOT FILE" && exit)
    echo "Processing file metadata..."
    PDFMETA=$(pdfinfo "$FILENAME")
    DOI=$(echo "$PDFMETA" | grep -Pio '10.\d{4,9}/[A-Z0-9./:;()-]+' | head -n 1)
    echo "$PDFMETA" | grep -Pi   '10.\d{4,9}/[A-Z0-9./:;()-]+'
    sleep $(shuf -i 1-10 -n 1)
    BIBDATA=$(curl -sLH "Accept: text/bibliography; style=bibtex" http://dx.doi.org/$DOI)
    echo "$BIBDATA" >> "$BIBFILE"

}


for file in *.pdf; do fetch "$file" & done
