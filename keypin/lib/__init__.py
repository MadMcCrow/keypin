import re
try :
    from rich import print as _rprint
except :
    pass

def print(text) :
    try :
        _rprint(text)
    except :
        __builtins__.print(re.sub("\[.*?\]", "", text))

globals()['print'] = print
