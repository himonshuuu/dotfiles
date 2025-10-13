autoload -Uz compinit

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "${ZSH_CACHE_DIR}/.zcompcache"

if [[ ! -f "${ZSH_CACHE_DIR}/.zcompdump" || "${ZSH_CACHE_DIR}/.zcompdump" -ot "${ZSH_CONFIG_DIR}" ]]; then
  compinit -d "${ZSH_CACHE_DIR}/.zcompdump"
else
  compinit -C -d "${ZSH_CACHE_DIR}/.zcompdump"
fi

COMPLETION_WAITING_DOTS="true"


