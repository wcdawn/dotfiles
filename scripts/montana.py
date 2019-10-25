#!/bin/python

# date and time
import datetime
import pytz

# curl
import requests

now = datetime.datetime.now(pytz.timezone('America/Denver'))
print('The time in Montana is:')
print(now.strftime('%a %w %b %Y %H:%M:%S %Z'))

r = requests.get('http://wttr.in/Missoula?0pqu')
missoula = r.text.splitlines()

r = requests.get('http://wttr.in/Flathead?0pqu')
flathead = r.text.splitlines()

for i in range(len(missoula)):
    print('{:30s}    {:s}'.format(missoula[i], flathead[i]))
