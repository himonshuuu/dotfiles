ZSH_CONFIG_DIR="${HOME}/.config/zsh"
ZSH_CACHE_DIR="${ZSH_CONFIG_DIR}/cache"

mkdir -p "${ZSH_CACHE_DIR}" "${ZSH_CONFIG_DIR}/completions"

fpath=("${ZSH_CONFIG_DIR}/completions" $fpath)

for file in "${ZSH_CONFIG_DIR}/conf.d/"*.zsh; do
  [[ -r "$file" ]] && source "$file"
done

ssh-add -q ~/ssh-keys/github    
# export ZDOTDIR="${HOME}/.config/zsh"
# if [[ -r "${ZDOTDIR}/.zshenv" ]]; then
#   source "${ZDOTDIR}/.zshenv"
# fi
# if [[ -r "${ZDOTDIR}/.zshrc" ]]; then
#   source "${ZDOTDIR}/.zshrc"
# fi
# bun completions
[ -s "/home/human/.bun/_bun" ] && source "/home/human/.bun/_bun"
