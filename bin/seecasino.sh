#!/bin/bash

ssh -qTfnN2 -D 8086 ibt014
tsocks wget --quiet http://intranet.fz-juelich.de/SharedDocs/Downloads/GC/DE/g-s/Speiseplan_aktuelle_Woche.pdf?__blob=publicationFile -O seecasino.pdf

nohup xdg-open seecasino.pdf >/dev/null 2>&1 & disown
