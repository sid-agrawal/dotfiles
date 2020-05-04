# show completion menu when number of options is at least 2
zstyle ':completion:*' menu select=2

zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
# zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Completion cache
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion::complete:*' cache-path /tmp/.zsh-cache-$USER

# My own style definitions
zstyle ':completion:*:my_bugs' sort no
zstyle '*:my_nogroup' list-grouped false

# color commands
# zstyle ':completion:*:*commands' list-colors "=(#b)([^ ]#)*=0=38;5;226"
# zstyle ':completion:*:*values' list-colors "=(#b)([^ ]#)*=0=38;5;119"

# color build ids
zstyle ':completion:*:build-id' list-colors \
   '=(#b)(#s)(<->)*@(<->)*((pass)|(fail)|-|cancel)*=0=38;5;81=38;5;11=0=38;5;40=38;5;160'
zstyle ':completion:*:build-id' sort no

# calendar stuff
zstyle ':datetime:calendar*:' calendar-file ~/.zsh/untracked/calendar
zstyle ':datetime:calendar*:' reformat-date yes

# vcs info
zstyle ':vcs_info:*' enable git
