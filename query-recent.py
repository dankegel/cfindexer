#!/usr/bin/env python3
# Retrieve ids of recently updated city council files.
#
# Input: nothing
# Output: prints one council file number per line to stdout

# See https://www.dataquest.io/blog/web-scraping-beautifulsoup/
#
# Frequently observed action types:
# 2 referred
# 4 Continued
# 5 document submitted
# 7 Scheduled for committee
# 14 Approved
# 18 Scheduled for council
# 22 community impact statment
# 25 referred - motion
# 34 introduced (rare)
# 44 Council adopted
# 45 Council action final
# 46 Council adopted forthwith
# 50 Expired file

# The action types we probably care about:
actions = [2, 5, 7, 18, 22, 25, 34]

import datetime
import re
import requests
import time
from bs4 import BeautifulSoup

now = datetime.date.today()
month = datetime.timedelta(days=31)
qurl = 'https://cityclerk.lacity.org/lacityclerkconnect/index.cfm?fa=vcfi.doSearch'
datafmt = "btnAdvanced=Search&searchform=advanced&ActionTaken=%s&ActDateStart=%s&ActDateEnd=%s"
headers = {"Content-Type": "application/x-www-form-urlencoded"}
cfnums = {}

# Can't do more than about a month without it clipping some results
for monthsago in range(1, 2):   # note: 2nd param is exclusive.  range(1,2) == [ 1 ]
 tstart = (now - monthsago * month).strftime('%m/%d/%Y')
 tend = (now - (monthsago-1) * month).strftime('%m/%d/%Y')
 for action in actions:
   data=datafmt % (action, tstart, tend)
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
