#!/bin/bash

# If the version is 1.9 or higher, run this
if tmux -V | awk '$2 >= 1.9 {exit} {exit 1}'; then
   tmux bind '"' split-window -c "#{pane_current_path}"
   tmux bind % split-window -h -c "#{pane_current_path}"
   tmux bind c new-window -c "#{pane_current_path}"
fi
