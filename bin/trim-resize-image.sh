#!/bin/bash

convert "$1" -trim -background none -gravity center -extent 105%x102% "${1%%.png}_final.png"
