#!/bin/bash

BG=none
EXTENT=105%x102%
OUTDIR=trimmed-resized

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -b|--background)
            BG=$2
            shift # past value
            shift # past value
            ;;
        -e|--extent)
            EXTENT=$2
            shift # past value
            shift # past value
            ;;
        -o|--outdir)
            OUTDIR=$2
            shift # past value
            shift # past value
            ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

mkdir -p "$OUTDIR"
mogrify -path "$OUTDIR/" -trim -background $BG -gravity center -extent $EXTENT "$@"
