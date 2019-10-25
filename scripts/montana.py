#!/bin/python

# date and time
import datetime
import pytz

# curl
import requests
import sys

# regex
import re

# 7-bit C1 ANSI sequences
ansi_escape = re.compile(r'''
    \x1B    # ESC
    [@-_]   # 7-bit C1 Fe
    [0-?]*  # Parameter bytes
    [ -/]*  # Intermediate bytes
    [@-~]   # Final byte
''', re.VERBOSE)

# date/time in Montana
now = datetime.datetime.now(pytz.timezone('America/Denver'))
print('The time in Montana is:')
print(now.strftime('%a %w %b %Y %H:%M:%S %Z'))

# weather
# this took a lot of work to get the column formatting proper
r = requests.get('http://wttr.in/Missoula?0pqu')
missoula = r.text
missoula_plain = ansi_escape.sub('', missoula).splitlines()
missoula = missoula.splitlines()

r = requests.get('http://wttr.in/Flathead?0pqu')
flathead = r.text
flathead_plain = ansi_escape.sub('', flathead).splitlines()
flathead = flathead.splitlines()

left_length = 30

missoula_stdout = []
for i in range(len(missoula)-1):
    missoula[i] = missoula[i].rstrip()
    flathead[i] = flathead[i].rstrip()
    blank_space = left_length - len(missoula_plain[i].rstrip())
    blank_line = ' ' * blank_space
    print('{:s}{:s}{:s}'.format(missoula[i], blank_line, flathead[i]))
print()

# days until
fname = '/home/wcdawn/hailey/next_visit.txt'
fobj = open(fname, 'r')
date_str = fobj.readlines()
fobj.close()

# strip removes leading whitespace, trailing whitespace, and newline characters
date_str = date_str[0].strip()
next_visit = datetime.datetime.strptime(date_str, '%Y-%m-%d')
now = datetime.datetime.now()
diff = next_visit - now
print('Days until next visit: {:d}'.format(diff.days + 1))
