import os
import atexit
import readline
import rlcompleter

if 'libedit' in readline.__doc__:
    readline.parse_and_bind('bind ^I rl_complete')
else:
    readline.parse_and_bind('tab: complete')

historyPath = os.path.expanduser('~/.pdbhistory')

def save_history(historyPath=historyPath):
   import readline
   readline.write_history_file(historyPath)

if os.path.exists(historyPath):
   readline.read_history_file(historyPath)

atexit.register(save_history)
del os, atexit, readline, rlcompleter, save_history, historyPath
