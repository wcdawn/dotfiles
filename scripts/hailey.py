#!/bin/python

# date and time
import datetime
import pytz

# curl
import requests
import sys

# weather
import forecastio

# regex
import re

# graphics/image
import PIL
from PIL import Image

def angleArrow(angle):
    if ((angle <= 0.0) or (angle > 360.0)):
        return ''
    elif ((angle <= 22.5) or (angle > 337.5)):
        return '↑'
    elif (angle <= 67.5):
        return '↗'
    elif (angle <= 112.5):
        return '→'
    elif (angle <= 157.5):
        return '↘'
    elif (angle <= 202.5):
        return '↓'
    elif (angle <= 247.5):
        return '↙'
    elif (angle <= 292.5):
        return '←'
    elif (angle <= 337.5):
        return '↖'
    return ''

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

if (False):
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

    left_length = 40

    missoula_stdout = []
    for i in range(len(missoula)-1):
        missoula[i] = missoula[i].rstrip()
        flathead[i] = flathead[i].rstrip()
        blank_space = left_length - len(missoula_plain[i].rstrip())
        blank_line = ' ' * blank_space
        print('{:s}{:s}{:s}'.format(missoula[i], blank_line, flathead[i]))
    print()

# my weather
api_key = '0b9e5fd389da8aba5b4b6450cc797dbb'
# FLBS
lat = 47.876957
lng = -114.032290
forecast = forecastio.load_forecast(api_key, lat, lng)
forecast_now = forecast.currently()

print()
print('Flathead')
print(forecast_now.summary)

temp = forecast_now.temperature
feels_like = forecast_now.apparentTemperature
if (abs(temp - feels_like) > 1.0):
    print('{:.0f} ({:.0f}) °F'.format(temp, feels_like))
else:
    print('{:.0f} °F'.format(temp))

try:
    wind_bearing_str = angleArrow(forecast_now.windBearing)
except:
    wind_bearing_str = ''
print('windSpeed = {:s} {:.1f} mph'.format(wind_bearing_str, 
    forecast_now.windSpeed))

print('Visibility = {:.1f} mi.'.format(forecast_now.visibility))

try:
    precip_accumulation = forecast_now.precipAccumulation
except:
    precip_accumulation = 0.0
print('Precip = {:.1f} in.'.format(precip_accumulation))
