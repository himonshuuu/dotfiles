alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git log --oneline --graph --decorate --all'
alias gch='git checkout'
alias gb='git branch'
alias gpl='git pull'
alias gd='git diff'
alias gcl='git clone'
alias clear='printf "\033c" && clear'
alias pup="paru -Syu"
alias pin="paru -S"
alias prm="paru -Rns"

alias ls='exa -al --color=always --group-directories-first --icons'
alias la='exa -a --color=always --group-directories-first --icons'
alias ll='exa -l --color=always --group-directories-first --icons'
alias l.='exa -ald --color=always --group-directories-first --icons .*'

alias tree='exa --icons -T'
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias cat='bat -p'

alias rsync-copy="rsync -avzP"
alias rsync-update="rsync -avzuP"

alias ssh-copy-id="ssh-copy-id"
alias sshkeygen="ssh-keygen"

alias zshconfig="nvim ~/.zshrc"
alias reloadzsh="source ~/.zshrc"
alias cls="clear"
alias grep="grep --color=auto"

