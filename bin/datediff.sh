#!/usr/bin/env bash


# d2=$(date -d now "+%s")

# while IFS='' read -r line || [[ -n "$line" ]]; do
#     IFS=':' read -ra a <<< "$line"
#     d1=$(date -d "${a[1]}" "+%s")
#     printf "${a[0]}:"
#     printf '%3s' "$(( (d1 - d2 + 86400)/86400 ))"
#     printf ' days\n'
# done < "$1"



datediff() {
    d1=$(date -d "$1" +%s)
    d2=$(date -d "$2" +%s)
    echo $(( (d1 - d2) / 86400 )) days
}


while IFS='' read -r line || [[ -n "$line" ]]; do
    IFS=':' read -ra a <<< "$line"
    dform=$(date  -d "${a[1]}" "+%Y %m %d")
    days=$(pdd $dform | cut -d ' ' -f4 | tr 'd' ' ' )
    # days=$(datediff "${a[1]}" today | sed 's/days//')

    printf "${a[0]}:"
    printf '%3s' $days
    printf ' days\n'
done < "$1"
