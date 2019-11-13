import re # regex
import sys

# 7-bit C1 ANSI sequences
# to use
# str_plain = ansi_escape.sub('', str)
ansi_escape = re.compile(r'''
    \x1B    # ESC
    [@-_]   # 7-bit C1 Fe
    [0-?]*  # Parameter bytes
    [ -/]*  # Intermediate bytes
    [@-~]   # Final byte
''', re.VERBOSE)

color_dict = {'black': '30', 'red': '31', 'green': '32', 'yellow': '33', 
        'blue': '34', 'magenta': '35', 'cyan': '36', 'white': '37'}


def ansiColor(string, color, **kwargs):
    isBold = kwargs.get('bold', False)
    extended_color = kwargs.get('extended_color', '')

    is256 = (color == '256')
    if ((is256) and (extended_color == '')):
        print('tried 256 color but no extended_color specified')
        sys.exit(1)

    prefix = '\033['

    if (is256):
        prefix += '38;5;'
        prefix += '{:d}'.format(extended_color)
    else:
        prefix += color_dict.get(color, '0')

    if (isBold):
        bold = ';1'
    else:
        bold = ''

    prefix += bold
    prefix += 'm'

    # reset character
    suffix = '\033[0m'

    return prefix + string + suffix
