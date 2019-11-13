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

# display an image
image_fname = '/home/wcdawn/hailey/christmas_pic/portland_canard.jpg'
image = Image.open(image_fname)
maxsize = (640, 640)
image.thumbnail(maxsize, PIL.Image.ANTIALIAS)
image.show()

# weather
location_dict = {
    'Missoula': [46.856339, -113.995292],
    'Flathead': [47.876957, -114.032290]}

weather_list = []

for key in location_dict:
    weather_list.append(weatherFormat(key, location_dict[key][0], 
            location_dict[key][1]))

padded_width = 40
for i in range(len(weather_list[0])):
    blank_size = padded_width - len(ansi_escape.sub('', weather_list[0][i]))
    print(weather_list[0][i] + blank_size * ' ' + weather_list[1][i])

