# Prepend "sudo" to the command line if it is not already there.

_add-prefix() {
   BUFFER="${1}${BUFFER}"
   CURSOR+=${#1}
}

_remove-prefix() {
   BUFFER=${BUFFER##$~1}
}

toggle-sudo() {
   if [[ "$BUFFER" = sudo\ *  ]]; then
      _remove-prefix 'sudo #'
   else
      _add-prefix 'sudo '
   fi
}
zle -N toggle-sudo
bindkey "^[s" toggle-sudo

toggle-vim() {
   if [[ "$BUFFER" != vim[a-z\ ]* ]]; then 
      if [[ "$BUFFER" = (ack|rg)* ]]; then
         _add-prefix "vim"
      else
         _add-prefix "vim "
      fi
   else
      _remove-prefix 'vim #'
   fi
}
zle -N toggle-vim
bindkey "^[v" toggle-vim

fzf-here() {
   </dev/tty file=$(fzf) && </dev/tty vim $file
}
zle -N fzf-here
bindkey "^[P" fzf-here

bindkey '^[m' beginning-of-line
bindkey '^[l' down-case-word
bindkey -s '^Xf' "find /src -maxdepth 5 -type f -name '*.py' | xargs grep --color -En "
bindkey -s '^XF' "find /src -maxdepth 5 -type f -name '*.tac' -or -name '*.*tin' | xargs grep --color -En "

bindkey -M menuselect '^o' accept-and-infer-next-history

function my-c-t {
   local x="${LBUFFER[-1]:- }${RBUFFER[1]:- }${RBUFFER[2]:- }"
   if [[ $x = '   ' ]]; then
      fzf-file-widget
   else
      zle transpose-chars
   fi
}
zle -N my-c-t
bindkey '^T' my-c-t

function my-c-r {
   if (( CURSOR ))
   then
      trap "bindkey '^R' my-c-r" INT EXIT
      bindkey '^R' history-incremental-search-backward
      zle history-incremental-search-backward
   else
      fzf-history-widget
   fi
}
zle -N my-c-r
bindkey '^R' my-c-r

bindkey '^[c' capitalize-word

autoload which-command
zle -N which-command

# autoload smart-insert-last-word
# zle -N insert-last-word smart-insert-last-word

autoload incarg
zle -N incarg
bindkey '^[+' incarg

bindkey '^[r' redo
bindkey '\eq' push-line-or-edit
