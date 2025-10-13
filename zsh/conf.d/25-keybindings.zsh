bindkey "^[[1;5C" forward-word      # ctrl+right
bindkey "^[[1;5D" backward-word     # ctrl+left

bindkey "^[[1;3C" forward-word      # alt+right
bindkey "^[[1;3D" backward-word     # alt+left

# Line navigation (ctrl+a/e for beginning/end of line)
bindkey "^A" beginning-of-line       # ctrl+a
bindkey "^E" end-of-line             # ctrl+e

# history navigation (ctrl+r/s for search backward/forward)
bindkey "^R" history-incremental-search-backward  # ctrl+r
bindkey "^S" history-incremental-search-forward   # ctrl+s

# delete word (ctrl+w)
bindkey "^W" backward-kill-word      # ctrl+w

# delete to end of line (ctrl+k)
bindkey "^K" kill-line               # ctrl+k

# delete to beginning of line (ctrl+u)
bindkey "^U" backward-kill-line      # ctrl+u

# fix autosuggestions behavior
# accept suggestion with ctrl+space
bindkey '^ ' autosuggest-accept

# clear suggestion with ctrl+backspace
bindkey '^H' autosuggest-clear
