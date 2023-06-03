#!/usr/bin/env python3

"""
Script to scrape content from sites. 
JUST USE `NEWSPAPER` INSTEAD!
"""

import requests
from bs4 import BeautifulSoup
from markdownify import markdownify as md
import re
import argparse

re_maincontent = re.compile(
        '|'.join(
            [r'maincontent', r'main-content', r'content']
            ),
        re.IGNORECASE
        )

def is_div_content(tag, content_regex):
    if tag.attrs:
        if content_regex.search(' '.join(tag.attrs.get('class', []))):
            return True
    return False

def match_tag_attr_by_regex(tag, attr, regex):
    if tag.attrs:
        if re_maincontent.search(tag.attrs.get('id')):
            return True
    return False

def soup_to_markdown(soup):
    return re.sub(r'\n\n+', r'\n\n' ,md(str(soup)))

def parse_args():
    ap = argparse.ArgumentParser()
    ap.add_argument("url", help="URL to parse")
    ap.add_argument('-d', '--dump', nargs='?', const="dump.html", help="dump entire soup as html file")
    ap.add_argument('-s', '--soup', action='store_true', help='output soup instead of markdown')
    args = ap.parse_args()
    return args

def main():
    # download web page
    args = parse_args()
    response = requests.get(args.url)
    html = response.content

# parse HTML content and remove non-relevant elements
    soup = BeautifulSoup(html, 'html.parser')

    if args.dump:
        with open(args.dump, 'w') as fp:
            fp.write(str(soup.prettify()))

    try: 
        soup = next(filter(lambda tag: match_tag_attr_by_regex(tag, 'id', re_maincontent) , soup.findAll()))
        # print("MAIN CONTENT:")
        # print(md(str(main_content)))
        # return
    except StopIteration:
        pass

# Remove unwanted tags
    for tag in soup(["script", "style", "meta", "link", "svg", "path", "img", "picture", "figure", "aside", "iframe"]):
        tag.extract()  # remove script and style tags

# Remove parent divs for buttons
    for b in soup.find_all('button'):
        if b.parent:
            b.parent.decompose()
        else:
            b.decompose()

# Remove irrelevant div classes 
    forbidden_div_classes = ['.*nav.*', '.*header.*', '.*privacy.*', '.*consent.*', '.*cookie.*', '.*share.*', '.*social.*', '.*news.*', '.*button.*', '.*footer.*', '.*sticky.*', '.*overlay.*']
    tempstr = '|'.join(forbidden_div_classes)
    re_forbidden_div_classes = re.compile(tempstr, re.IGNORECASE)

    for div in soup.find_all('div'):
        if div.attrs:
            classes = div.attrs.get('class', [])
            id = div.attrs.get('id', '')
            matches = re_forbidden_div_classes.search(' '.join(classes) + f' {id}')
            if matches: 
                div.decompose()

# # Print div classes with content
#     div_classes_content = ['.*content.*']
#     content_regex = re.compile('|'.join(div_classes_content), re.IGNORECASE)
#     for div in soup.find_all('div'):
#         if match_tag_attr_by_regex(div, 'class', content_regex)
#             print("-----")
#             print(md(str(div)))
#             print("-----")

    if args.soup: 
        print(soup.prettify())
    else:
        print(soup_to_markdown(soup))

if __name__ == "__main__":
    main()
