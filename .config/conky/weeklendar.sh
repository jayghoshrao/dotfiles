#!/bin/bash

headline=$(cal -h | grep Su)

now=$(date "+%d")
now_=$(date "+%_d")

full=$(cal | grep -w $now_)
before=""
after=""

for i in $full
do
	if [ $i -lt $now ]
	then
	#before+=$i" "
	before+="  X  "
	elif [ $i -gt $now ]
	then
#		if [ $i -lt 10 ]
#		then
#       		after+=_$i" "
#		else
		after+=$i" "
#		fi

	fi
done

#echo $headline
echo $before $now_ $after

