#!/bin/python

import requests
from bs4 import BeautifulSoup as bs
import datetime as dt

BOLD = '\033[1m'
END = '\033[0m'
OKGREEN = '\033[92m'

# for each in list:
#     print('{}{}{}'.format(BOLD, each, END))


# url="http://www.studierendenwerk-aachen.de/en/eating-drinking/mensa-academica-wochenplan-en-kopie.html"
mensa_academica_url="http://www.studierendenwerk-aachen.de/speiseplaene/academica-w-en.html"

try:
    response = requests.get(mensa_academica_url)
    iframe_soup = bs(response.content, "html.parser")
    weekMenu = iframe_soup.findAll("table", {"class":"menues"})

    day = dt.datetime.today().weekday()

    for item in weekMenu[day].contents[0].contents:
        item_cat = item.find('span', {'class':'menue-item menue-category'}).text
        item_food = item.find('span', {'class':'expand-nutr'}).text
        if ('Vegetarian' in item_cat):
            print('{}{}{}{}'.format(OKGREEN, BOLD, item_cat+" : "+item_food, END))
        else:
            print(item_cat+" : "+item_food)
except:
    print("An error occurred.")
