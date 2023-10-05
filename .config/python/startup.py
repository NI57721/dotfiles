#!/usr/bin/env python3

import atexit
import readline
import os

# save history file as $XDG_CACHE_HOME/python/history
histfile = os.path.join(os.path.expanduser('~/.local/share/python'), 'history')

try:
    readline.read_history_file(histfile)
    readline.set_history_length(1000)
except FileNotFoundError:
    pass

atexit.register(readline.write_history_file, histfile)

