import numpy as np
import forecastio # python-forecastio
from ansi import ansi_escape, ansiColor

# my weather
api_key = '0b9e5fd389da8aba5b4b6450cc797dbb'

# dictionary of pretty pictures
# from the wego project https://github.com/schachmat/wego under ISC license
weather_graphic = {
    'unknown' :
    ['    .-.      ',
     '     __)     ',
     '    (        ',
     '     `-᾿     ',
     '      •      '],
    'cloudy' : 
    ['             ',
     '\033[38;5;250m     .--.    \033[0m',
     '\033[38;5;250m  .-(    ).  \033[0m',
     '\033[38;5;250m (___.__)__) \033[0m',
     '             '],
    'fog' : 
    ['             ',
     '\033[38;5;251m _ - _ - _ - \033[0m',
     '\033[38;5;251m  _ - _ - _  \033[0m',
     '\033[38;5;251m _ - _ - _ - \033[0m',
     '             '],
    'heavy-rain' : # TODO this may be unused
    ['\033[38;5;240;1m     .-.     \033[0m',
     '\033[38;5;240;1m    (   ).   \033[0m',
     '\033[38;5;240;1m   (___(__)  \033[0m',
     '\033[38;5;21;1m  ‚ʻ‚ʻ‚ʻ‚ʻ   \033[0m',
     '\033[38;5;21;1m  ‚ʻ‚ʻ‚ʻ‚ʻ   \033[0m'],
    'heavy-showers' : # TODO this may be unused
    ['\033[38;5;226m _`/\'\'\033[38;5;240;1m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;240;1m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;240;1m(___(__) \033[0m',
     '\033[38;5;21;1m   ‚ʻ‚ʻ‚ʻ‚ʻ  \033[0m',
     '\033[38;5;21;1m   ‚ʻ‚ʻ‚ʻ‚ʻ  \033[0m'],
    'heavy-snow': # TODO this may be unused
    ['\033[38;5;240;1m     .-.     \033[0m',
     '\033[38;5;240;1m    (   ).   \033[0m',
     '\033[38;5;240;1m   (___(__)  \033[0m',
     '\033[38;5;255;1m   * * * *   \033[0m',
     '\033[38;5;255;1m  * * * *    \033[0m'],
    'heavy-snow-showers' : # TODO this may be unused
    ['\033[38;5;226m _`/\'\'\033[38;5;240;1m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;240;1m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;240;1m(___(__) \033[0m',
     '\033[38;5;255;1m    * * * *  \033[0m',
     '\033[38;5;255;1m   * * * *   \033[0m'],
    'rain' :
    ['\033[38;5;250m     .-.     \033[0m',
     '\033[38;5;250m    (   ).   \033[0m',
     '\033[38;5;250m   (___(__)  \033[0m',
     '\033[38;5;111m    ʻ ʻ ʻ ʻ  \033[0m',
     '\033[38;5;111m   ʻ ʻ ʻ ʻ   \033[0m'],
    'light-showers' : # TODO this may be unused
    ['\033[38;5;226m _`/\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '\033[38;5;111m     ʻ ʻ ʻ ʻ \033[0m',
     '\033[38;5;111m    ʻ ʻ ʻ ʻ  \033[0m'],
    'sleet':
    ['\033[38;5;250m     .-.     \033[0m',
     '\033[38;5;250m    (   ).   \033[0m',
     '\033[38;5;250m   (___(__)  \033[0m',
     '\033[38;5;111m    ʻ \033[38;5;255m*\033[38;5;111m ʻ \033[38;5;255m*  \033[0m',
     '\033[38;5;255m   *\033[38;5;111m ʻ \033[38;5;255m*\033[38;5;111m ʻ   \033[0m'],
    'light-sleet-showers' : # TODO this may be unused
    ['\033[38;5;226m _`/\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '\033[38;5;111m     ʻ \033[38;5;255m*\033[38;5;111m ʻ \033[38;5;255m* \033[0m',
     '\033[38;5;255m    *\033[38;5;111m ʻ \033[38;5;255m*\033[38;5;111m ʻ  \033[0m'],
    'snow' :
    ['\033[38;5;250m     .-.     \033[0m',
     '\033[38;5;250m    (   ).   \033[0m',
     '\033[38;5;250m   (___(__)  \033[0m',
     '\033[38;5;255m    *  *  *  \033[0m',
     '\033[38;5;255m   *  *  *   \033[0m'],
    'light-snow-showers' : # TODO this may be unused
    ['\033[38;5;226m _`/\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '\033[38;5;255m     *  *  * \033[0m',
     '\033[38;5;255m    *  *  *  \033[0m'],
    'partly-cloudy-day' :
    ['\033[38;5;226m   \\  /\033[0m      ',
     '\033[38;5;226m _ /\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m   \\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '             '],
    'partly-cloudy-night' : # same as partly-cloudy-day
    ['\033[38;5;226m   \\  /\033[0m      ',
     '\033[38;5;226m _ /\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m   \\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '             '],
    'clear-day' :
    ['\033[38;5;226m    \\   /    \033[0m',
     '\033[38;5;226m     .-.     \033[0m',
     '\033[38;5;226m  ‒ (   ) ‒  \033[0m',
     '\033[38;5;226m     `-᾿     \033[0m',
     '\033[38;5;226m    /   \\    \033[0m'],
    'clear-night' : # same as clear-day
    ['\033[38;5;226m    \\   /    \033[0m',
     '\033[38;5;226m     .-.     \033[0m',
     '\033[38;5;226m  ‒ (   ) ‒  \033[0m',
     '\033[38;5;226m     `-᾿     \033[0m',
     '\033[38;5;226m    /   \\    \033[0m'],
    'thundery-heavy-rain' : # TODO this may be unused
    ['\033[38;5;240;1m     .-.     \033[0m',
     '\033[38;5;240;1m    (   ).   \033[0m',
     '\033[38;5;240;1m   (___(__)  \033[0m',
     '\033[38;5;21;1m  ‚ʻ\033[38;5;228;5m⚡\033[38;5;21;25mʻ‚\033[38;5;228;5m⚡\033[38;5;21;25m‚ʻ   \033[0m',
     '\033[38;5;21;1m  ‚ʻ‚ʻ\033[38;5;228;5m⚡\033[38;5;21;25mʻ‚ʻ   \033[0m'],
    'thunderstorm' :
    ['\033[38;5;226m _`/\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '\033[38;5;228;5m    ⚡\033[38;5;111;25mʻ ʻ\033[38;5;228;5m⚡\033[38;5;111;25mʻ ʻ \033[0m',
     '\033[38;5;111m    ʻ ʻ ʻ ʻ  \033[0m'],
    'thundery-snow-showers' : # TODO this may be unused
    ['\033[38;5;226m _`/\'\'\033[38;5;250m.-.    \033[0m',
     '\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m',
     '\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m',
     '\033[38;5;255m     *\033[38;5;228;5m⚡\033[38;5;255;25m *\033[38;5;228;5m⚡\033[38;5;255;25m * \033[0m',
     '\033[38;5;255m    *  *  *  \033[0m'],
    'very-cloudy' : # TODO this may be unused
    ['             ',
     '\033[38;5;240;1m     .--.    \033[0m',
     '\033[38;5;240;1m  .-(    ).  \033[0m',
     '\033[38;5;240;1m (___.__)__) \033[0m',
     '             ']
    }

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

def twoColumn(left, right, **kwargs):

    left_length = kwargs.get('left_length', 40)

    left_plain = []
    for line in left:
        left_plain.append(ansi_escape.sub('', line))

    right_plain = []
    for line in right:
        right_plain.append(ansi_escape.sub('', line))

    out = []
    for i in range(len(left)):
        left[i] = left[i].rstrip()
        right[i] = right[i].rstrip()
        blank_space = left_length - len(left_plain[i].rstrip())
        blank_line = ' ' * blank_space
        out.append('{:s}{:s}{:s}'.format(left[i], blank_line, right[i]))
    return out

def tempColor(temp):
    temp_arr = np.array([
        [5, 21],
        [10, 27],
        [16, 33],
        [21, 39], 
        [27, 45],
        [32, 51], 
        [36, 50], 
        [39, 49], 
        [43, 48], 
        [46, 47],
        [50, 46], 
        [55, 82], 
        [61, 118], 
        [66, 154], 
        [72, 190],
        [77, 226], 
        [82, 220], 
        [87, 214], 
        [93, 208], 
        [99, 202]])

    for i in range(temp_arr.shape[0]):
        if (temp < temp_arr[i][0]):
            return ansiColor('{:.0f}'.format(temp), '256',
                    extended_color=temp_arr[i][1])

    return ansiColor('{:0f}'.format(temp), 'red', bold=True)

def windColor(wind):
    wind_arr = np.array([
        [0, 46],
        [6, 82],
        [11, 118],
        [16, 154],
        [21, 190],
        [26, 226],
        [32, 220],
        [39, 214],
        [45, 208],
        [52, 202]])

    for i in range(wind_arr.shape[0]):
        if (wind < wind_arr[i][0]):
            return ansiColor('{:.0f}'.format(wind), '256',
                    extended_color=wind_arr[i][1])

    return ansiColor('{:.1f}'.format(wind), 'red', bold=True)

def weatherFormat(name, lat, lng):

    forecast = forecastio.load_forecast(api_key, lat, lng)
    forecast_now = forecast.currently()
    forecast_today = forecast.daily().data[0]

    out = []
    data = []

    out.append(name)

    data.append(forecast_now.summary)

    hi = tempColor(forecast_today.temperatureMax)
    lo = tempColor(forecast_today.temperatureMin)
    data.append('Hi: {:s} °F | Lo: {:s} °F'.format(hi, lo))

    temp = forecast_now.temperature
    feels_like = forecast_now.apparentTemperature
    temp_str = tempColor(temp)
    feels_like_str = tempColor(feels_like)
    if (abs(temp - feels_like) > 1.0):
        data.append('Currently: {:s} ({:s}) °F'.format(temp_str, feels_like_str))
    else:
        data.append('Currently: {:s} °F'.format(temp_str))

    try:
        wind_bearing_str = angleArrow(forecast_now.windBearing)
    except:
        wind_bearing_str = ''
    wind_speed_str = windColor(forecast_now.windSpeed)
    data.append('{:s} {:s} mph'.format(wind_bearing_str, wind_speed_str))

    data.append('{:.1f} mi.'.format(forecast_now.visibility))

    try:
        precip_accumulation = forecast_now.precipAccumulation
    except:
        precip_accumulation = 0.0
    data.append('{:.1f} in. | {:.0f}%'.format(precip_accumulation,
        forecast_now.precipProbability * 100.0))

    icon = weather_graphic.get(forecast_now.icon, weather_graphic['unknown'])

    icon_padded_width = 15
    icon_default_width = len(ansi_escape.sub('', icon[0]))

    for i in range(max(len(icon), len(data))):
        if (i >= len(icon)):
            data[i] = ' ' * icon_padded_width + data[i].strip()
        elif (i >= len(data)):
            data.append(icon[i])
        else:
            data[i] = icon[i] + \
                (icon_padded_width - icon_default_width) * ' ' + data[i]

    for line in data:
        out.append(line)

    return out
