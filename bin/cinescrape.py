#!/bin/python

import requests
from bs4 import BeautifulSoup as bs
import sys
import os
import re

# URL = "https://www.cineplex.de/filmreihe/internationale-filme-in-ov/869/aachen/"
URL = "https://www.cineplex.de/filmreihe/englische-ov/1999/koeln/"
BASE_URL = "https://www.cineplex.de"

req = requests.get(URL)
soup = bs(req.content, "html.parser")
data = soup.findAll("div", {"class":"movie-schedule--details"})

for movie in data:
    filmInfo = movie.find("a", {"class":"filmInfoLink"})
    title = filmInfo.next
    link = BASE_URL + filmInfo['href']
    date = movie.find("time", {"class":"schedule__date font__bold"}).next
    time = movie.find("time", {"class":"schedule__time font__light" }).next
    # print(title, date, time, link)

    print (title)
    print ("    ", date, time)
    print ("    ", link)
