autoload -Uz compinit
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'       # Case insensitive tab completion
zstyle ':completion:*' rehash true                              # automatically find new executables in path 
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"         # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' completer _expand _complete _ignored _approximate
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt '%SScrolling active: current selection at %p%s'
zstyle ':completion:*:descriptions' format '%U%F{cyan}%d%f%u'

# Speed up completions
zstyle ':completion:*' accept-exact '*(N)'
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}/.zcompcache"

autoload -U +X bashcompinit && bashcompinit

if [[ ! -f "${ZSH_CACHE_DIR}/.zcompdump" || "${ZSH_CACHE_DIR}/.zcompdump" -ot "${ZSH_CONFIG_DIR}" ]]; then
  compinit -d "${ZSH_CACHE_DIR}/.zcompdump"
else
  compinit -C -d "${ZSH_CACHE_DIR}/.zcompdump"
fi

COMPLETION_WAITING_DOTS="true"


