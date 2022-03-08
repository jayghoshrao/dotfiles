#!/bin/bash

mkdir trimmed-resized
mogrify -path trimmed-resized/ -trim -background none -gravity center -extent 105%x102% "$@"
