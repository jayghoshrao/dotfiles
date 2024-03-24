#!/bin/bash

NCHUNKS=1
COMMAND="echo"
FILEGLOB="*"

# Sorting parameters
FIELDSEP='_'
KEY=2

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"
    case $key in
        -n|--nchunks)
            NCHUNKS=$2
            shift; shift ;;
        -c|--command)
            COMMAND="$2"
            shift; shift ;;
        -C|--command-all)
            COMMAND="${@:2}"
            shift $# ;;
        -t|--field-separator)
            FIELDSEP="$2"
            shift; shift ;;
        -k|--key)
            KEY="$2"
            shift; shift ;;
        -e|--expression)
            FILEGLOB="$2"
            shift; shift ;;
        *)    # unknown option
            POSITIONAL+=("$1") # save it in an array for later
            shift # past argument
            ;;
    esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

# Check if the argument provided is a positive integer
if ! [[ $NCHUNKS =~ ^[1-9][0-9]*$ ]]; then
    echo "Error: Number of chunks must be a positive integer."
    exit 1
fi


# Create an array of file names matching the pattern
# files=(*.pvtu)
# files=($FILEGLOB)
files=($(eval "echo ${FILEGLOB}"))

# Check if there are files matching the pattern
if [ ${#files[@]} -eq 0 ]; then
    echo "No files found matching the pattern."
    exit 1
fi

# Sort the array numerically
sorted_files=($(printf '%s\n' "${files[@]}" | sort -t "$FIELDSEP" -k "$KEY" -n))

# Calculate the number of files in each chunk
chunk_size=$(( (${#sorted_files[@]} + NCHUNKS - 1) / NCHUNKS ))

# Split the sorted array into chunks
for ((i = 0; i < ${#sorted_files[@]}; i += chunk_size)); do
    chunk=("${sorted_files[@]:i:chunk_size}")
    ii=$(( i / chunk_size ))
    ICOMMAND=$(echo "$COMMAND" | sed "s/{ICHUNK}/$ii/g")
    $ICOMMAND "${chunk[@]}"
done
