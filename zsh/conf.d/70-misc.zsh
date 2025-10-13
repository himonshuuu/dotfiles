export GIT_STATUS_CHECK_IGNORE_SUBMODULES=1
export GIT_TERMINAL_PROMPT=1

_pup_complete() {
  _arguments '*:package: _aur_packages'
}
compdef _paru pup