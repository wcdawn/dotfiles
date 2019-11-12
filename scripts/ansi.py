import re # regex

# 7-bit C1 ANSI sequences
# to use
# str_plain = ansi_escape.sub('', str).splitlines()
ansi_escape = re.compile(r'''
    \x1B    # ESC
    [@-_]   # 7-bit C1 Fe
    [0-?]*  # Parameter bytes
    [ -/]*  # Intermediate bytes
    [@-~]   # Final byte
''', re.VERBOSE)

