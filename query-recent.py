#!/usr/bin/env python3
# Retrieve ids of recently updated city council files.
#
# Input: nothing
# Output: prints one council file number per line to stdout

# See https://www.dataquest.io/blog/web-scraping-beautifulsoup/

import datetime
import re
import requests
import time
from bs4 import BeautifulSoup

now = datetime.date.today()
week = datetime.timedelta(weeks=1)
last_week = (now - week).strftime('%m/%d/%Y')
next_week = (now + week).strftime('%m/%d/%Y')
qurl = 'https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=vcfi.doSearch'
datafmt = "btnAdvanced=Search&searchform=advanced&ActionTaken=%s&ActDateStart=%s&ActDateEnd=%s"
headers = {"Content-Type": "application/x-www-form-urlencoded"}
# 2 referred
# 5 document submitted
# 22 community impact statment
# 25 referred - motion
# 34 introduced (rare)
cfnums = {}
for action in [2, 5, 22, 25, 34]:
   data=datafmt % (action, last_week, next_week)
   response = requests.post(qurl, data=data, headers=headers)
   soup = BeautifulSoup(response.text, 'html.parser')
   links = soup.find_all(href=re.compile("cfnumber"))
   for link in links:
      lurl = link.get('href')
      # urls are foo=bar&cfnum=88-9999, so want part after 2nd =
      cfnum = lurl.split('=', 2)[-1]
      cfnums[cfnum] = 1
for cfnum in sorted(cfnums):
   print(cfnum)
