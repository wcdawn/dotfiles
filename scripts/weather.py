import forecastio # python-forecastio

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
    'heavy-snow ': # TODO this may be unused
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
    'snow' : # TODO this may be unused
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

def weatherFormat(lat, lng):

    forecast = forecastio.load_forecast(api_key, lat, lng)
    forecast_now = forecast.currently()
    forecast_today = forecast.daily().data[0]

    out = ['']

    out.append('{:.6f}, {:.6f}'.format(lat, lng))
    out.append('Flathead')
    out.append(forecast_now.summary)

    out.append('Hi: {:.0f} °F | Lo: {:.0f} °F'.format(forecast_today.temperatureMax, 
        forecast_today.temperatureMin))

    temp = forecast_now.temperature
    feels_like = forecast_now.apparentTemperature
    if (abs(temp - feels_like) > 1.0):
        out.append('{:.0f} ({:.0f}) °F'.format(temp, feels_like))
    else:
        out.append('{:.0f} °F'.format(temp))

    try:
        wind_bearing_str = angleArrow(forecast_now.windBearing)
    except:
        wind_bearing_str = ''
    out.append('windSpeed = {:s} {:.1f} mph'.format(wind_bearing_str, 
        forecast_now.windSpeed))

    out.append('Visibility = {:.1f} mi.'.format(forecast_now.visibility))

    try:
        precip_accumulation = forecast_now.precipAccumulation
    except:
        precip_accumulation = 0.0
    out.append('Precip = {:.1f} in. | {:.0f}%'.format(precip_accumulation,
        forecast_now.precipProbability * 100.0))

    icon = weather_graphic.get(forecast_now.icon, weather_graphic['unknown'])
    for line in icon:
        out.append(line)

    return out

