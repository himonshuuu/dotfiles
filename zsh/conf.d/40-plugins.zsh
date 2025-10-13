if [[ ! -f "${HOME}/.zinit/bin/zinit.zsh" ]]; then
  mkdir -p "${HOME}/.zinit" && \
  git clone https://github.com/zdharma-continuum/zinit.git "${HOME}/.zinit/bin"
fi

source "${HOME}/.zinit/bin/zinit.zsh"

zinit ice wait lucid
zinit light zsh-users/zsh-completions

zinit ice wait lucid
zinit light zsh-users/zsh-syntax-highlighting

zinit ice wait lucid
zinit light zsh-users/zsh-autosuggestions


