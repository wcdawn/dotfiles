#!/bin/python

# date and time
import datetime
import pytz

# curl
import requests
import sys

# weather
from weather import weatherFormat, twoColumn
from ansi import ansi_escape

# graphics/image
import PIL
from PIL import Image

# date/time in Montana
now = datetime.datetime.now(pytz.timezone('America/Denver'))
print('The time in Montana is:')
print(now.strftime('%a %w %b %Y %H:%M:%S %Z'))


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
print()
print('Days until next visit: {:d}'.format(diff.days + 1))

if (False):
    # display an image
    image_fname = '/home/wcdawn/hailey/christmas_pic/portland_canard.jpg'
    image = Image.open(image_fname)
    maxsize = (640, 640)
    image.thumbnail(maxsize, PIL.Image.ANTIALIAS)
    image.show()

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

out = twoColumn(missoula, flathead)
for line in out:
    print(line)

left_length = 40

missoula_stdout = []
for i in range(len(missoula)):
    missoula[i] = missoula[i].rstrip()
    flathead[i] = flathead[i].rstrip()
    blank_space = left_length - len(missoula_plain[i].rstrip())
    blank_line = ' ' * blank_space
    print('{:s}{:s}{:s}'.format(missoula[i], blank_line, flathead[i]))
print()

# FLBS
lat = 47.876957
lng = -114.032290
print_weather = weatherFormat(lat, lng)
for line in print_weather:
    print(line)
