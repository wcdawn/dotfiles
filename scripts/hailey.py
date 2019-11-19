#!/bin/python

# argument processing
import sys, getopt

# date and time
import datetime
import pytz

# weather
from weather import weatherFormat, twoColumn
from ansi import ansi_escape

# graphics/image
import PIL
from PIL import Image

# webcams
import webcam

# default options
doWeather = True
doImage = True
whichWebcam = 0

# logical input
# -w -- do weather
# -i -- do image
# integer input
# -c -- (1,2) for (lake_view, tree_view) webcam

# arguemnt processing
myopts, args = getopt.getopt(sys.argv[1:], 'w:i:c:')
# o -- option
# a -- argument
for o, a in myopts:
    if o == '-w':
        doWeather = bool(int(a))
    elif o == '-i':
        doImage = bool(int(a))
    elif o == '-c':
        whichWebcam = int(a)
    else:
        print(o, a)
        print('Usage: {:s}')

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
if (doImage):
    image = Image.open(image_fname)
    maxsize = (640, 640)
    image.thumbnail(maxsize, PIL.Image.ANTIALIAS)
    image.show()

# weather
location_dict = {
    'Missoula': [46.856339, -113.995292],
    'Flathead': [47.876957, -114.032290]}
if (doWeather):
    weather_list = []

    for key in location_dict:
        weather_list.append(weatherFormat(key, location_dict[key][0], 
                location_dict[key][1]))

    padded_width = 40
    for i in range(len(weather_list[0])):
        blank_size = padded_width - len(ansi_escape.sub('', weather_list[0][i]))
        print(weather_list[0][i] + blank_size * ' ' + weather_list[1][i])

# webcams
# http://webcam.flbs.umt.edu/view/viewer_index.shtml?id=2731
lake_view = 'http://webcam.flbs.umt.edu/mjpg/video.mjpg'
# http://webcam2.flbs.umt.edu/view/viewer_index.shtml?id=4824
tree_view = 'http://webcam2.flbs.umt.edu/mjpg/video.mjpg'

if (whichWebcam == 1):
    webcam.dispWebcam(lake_view)
elif (whichWebcam == 2):
    webcam.dispWebcam(tree_view)
