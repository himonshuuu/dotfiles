PROMPTTY_ROOT="$HOME/.config/zsh"
PROMPTTY_DEBUG="${PROMPTTY_DEBUG:-0}"

COLOR_BLACK=0
COLOR_RED=1
COLOR_GREEN=2
COLOR_YELLOW=3
COLOR_BLUE=4
COLOR_MAGENTA=5
COLOR_CYAN=6
COLOR_WHITE=7

_FG_EXIT=$COLOR_BLACK
_BG_EXIT=$COLOR_BLUE

_TEXC_MIN=1

_FG_USER=$COLOR_WHITE
_BG_USER=$COLOR_BLACK

_FG_DIR=$COLOR_BLUE
_BG_DIR=$COLOR_BLACK

_FG_GIT=$COLOR_BLACK
_BG_GIT=$COLOR_MAGENTA

_BG_LIGHT_RED=$COLOR_RED

COLOR_RESET="%f"

_USER_FORMAT=" %n"
_USER_FORMAT_ROOT=" %n"

char_left=$'\ue0b6'
char_right=$'\ue0b4'

_SHOW_GAP=1
ICON_BRANCH="󰘬"
ICON_AHEAD="⇡"
ICON_BEHIND="⇣"
ICON_STAGED="*"
ICON_UNSTAGED="+"
ICON_UNTRACKED="?"
ICON_STASHED=""
ICON_CLEAN=" "

ICON_ARCH=" "

PROMPTTY_LPROMPT=""
PROMPTTY_RPROMPT=""
PROMPTTY_DATA_GITINFO=""
PROMPTTY_DATA_TEXC=""
PROMPTTY_DATA_DIR=""
PROMPTTY_RAW_TEXC=0
PROMPTTY_DRAW_GAP=0

PROMPTTY_SHOWN_ARCH=0
PROMPTTY_FIRST_PROMPT=1
PROMPTTY_HAS_DRAWN_GAP=0
PROMPTTY_LAST_CMD_IS_CLEAR=0
PROMPTTY_IS_FIRST_PROMPT=1
PROMPTTY_LAST_EXIT=0  
PROMPTTY_LAST_COMMAND=0

debug_log() {
  (( PROMPTTY_DEBUG )) && echo "[PROMPTTY DEBUG] $*" >&2
}

get_gitinfo() {
  debug_log "get_gitinfo called with: $1"

  if ! command -v git &>/dev/null; then
    debug_log "ERROR: git is not available"
    return 1
  fi

  local git_dir branch ahead behind staged unstaged untracked stashed clean status_out upstream

  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    debug_log "INFO: not a git repo in $1"
    return 1
  fi

  debug_log "detected git repo in $1"

  status_out=$(git -C "$1" status --porcelain=2 --branch 2>/dev/null)

  if [[ -z $status_out ]]; then
    debug_log "ERROR: git status is empty or failed"
    return 1
  fi

  debug_log "git status output length: ${#status_out}"

  branch=$(echo "$status_out" | awk '/^# branch\.head /{print $3}')
  if [[ -z $branch || $branch == "(detached)" ]]; then
    branch=$(git -C "$1" rev-parse --short HEAD 2>/dev/null)
  fi
  debug_log "branch: $branch"

  upstream=$(echo "$status_out" | awk '/^# branch\.upstream /{print $3}')
  debug_log "upstream: $upstream"

  ahead=$(echo "$status_out" | awk '/^# branch\.ab /{print $4}' | sed 's/+\([0-9]*\).*/\1/')
  behind=$(echo "$status_out" | awk '/^# branch\.ab /{print $5}' | sed 's/-\([0-9]*\).*/\1/')

  [[ -z $ahead ]] && ahead=0
  [[ -z $behind ]] && behind=0
  debug_log "ahead: $ahead, behind: $behind"

  staged=$(echo "$status_out" | awk '$1 ~ /^[1-2]/ && $2 != $3 {print}' | wc -l | tr -d " ")
  unstaged=$(echo "$status_out" | awk '$1 ~ /^[1-2]/ && $2 == $3 && $4 != $5 {print}' | wc -l | tr -d " ")
  untracked=$(echo "$status_out" | awk '$1 == "?" {print}' | wc -l | tr -d " ")

  debug_log "staged: $staged, unstaged: $unstaged, untracked: $untracked"

  stashed=0
  if git -C "$1" rev-parse --git-dir &>/dev/null; then
    local gd
    gd=$(git -C "$1" rev-parse --git-dir 2>/dev/null)
    if [[ -d "$gd/refs/stash" || -f "$gd/logs/refs/stash" ]]; then
      stashed=$(git -C "$1" stash list 2>/dev/null | wc -l | tr -d " ")
    fi
  fi
  debug_log "stashed: $stashed"

  clean=0
  ((staged == 0 && unstaged == 0 && untracked == 0)) && clean=1
  debug_log "clean: $clean"

  local out=""
  [[ -n $branch ]] && out+="%F{$_BG_EXIT}${char_left}%K{$_BG_EXIT}%F{$_FG_EXIT}${ICON_BRANCH} ${branch} "

  (( ahead > 0 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_AHEAD}${ahead}"
  (( behind > 0 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_BEHIND}${behind}"
  (( staged > 0 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_STAGED}${staged}"
  (( unstaged > 0 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_UNSTAGED}${unstaged}"
  (( untracked > 0 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_UNTRACKED}${untracked}"
  (( stashed > 0 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_STASHED}${stashed}"
  (( clean == 1 )) && out+="%F{$_BG_LIGHT_RED}${char_left}%K{$_BG_LIGHT_RED}%F{$_FG_EXIT}${ICON_CLEAN}"

  if [[ -n $out ]]; then
    debug_log "git info output: $out"
    printf '%s' "$out"
    return 0
  else
    debug_log "WARNING: no git info to display"
    return 1
  fi
}

get_texc() {
  (( PROMPTTY_RAW_TEXC )) || return
  local duration=$(( EPOCHSECONDS - PROMPTTY_RAW_TEXC ))
  (( duration >= _TEXC_MIN )) || return
  local out=""
  local d h m s
  d=$(( duration / 86400 ))
  h=$(( (duration % 86400) / 3600 ))
  m=$(( (duration % 3600) / 60 ))
  s=$(( duration % 60 ))
  [[ $d -gt 0 ]] && out+="${d}d"
  [[ $h -gt 0 ]] && out+="${h}h"
  [[ $m -gt 0 ]] && out+="${m}m"
  out+="${s}s"
  printf '%s' "$out"
}

get_dir() {
  print -P "%1~"
}

prompt_left() {
  local p
  local show_arch=0

  if (( PROMPTTY_FIRST_PROMPT )); then
    show_arch=1
    PROMPTTY_FIRST_PROMPT=0
  elif [[ -n "${PROMPTTY_WAS_EMPTY}" && "${PROMPTTY_WAS_EMPTY}" == "1" ]]; then
    show_arch=1
  fi

  if (( show_arch )); then
    p+="%F{$_BG_EXIT}${char_left}%K{$_BG_EXIT}%F{$_FG_EXIT}${ICON_ARCH}"
  fi

  p+="%K{$_BG_USER}%F{$_BG_EXIT}${char_right}"
  p+="%K{$_BG_USER}%F{$_FG_USER}"
  p+="%(#.${_USER_FORMAT_ROOT}.${_USER_FORMAT})"
  p+="%k%F{$_BG_USER}${char_right}%f"
  p+=" "
  PROMPTTY_LPROMPT="$p"
  PROMPT="$PROMPTTY_LPROMPT"
}

prompt_right() {
  local p
  p+="%F{$_BG_DIR}${char_left}%K{$_BG_DIR}%F{$_FG_DIR}${PROMPTTY_DATA_DIR}%k%F{$_BG_DIR}%K{$_BG_DIR}${char_left}"

  if [[ -n ${PROMPTTY_DATA_TEXC} ]]; then
    p+=" %F{$_BG_DIR}%K{$_BG_DIR}%F{$_FG_DIR}${PROMPTTY_DATA_TEXC}%k%f"
  fi

  if [[ -n ${PROMPTTY_DATA_GITINFO} ]]; then
    p+="${PROMPTTY_DATA_GITINFO}%k%f"
    p+="%k%F{$_BG_LIGHT_RED}${char_right}%k%f"
  else
    p+="%k%F{$_BG_DIR}${char_right}%k%f"
  fi

  PROMPTTY_RPROMPT="$p"
  RPROMPT="$PROMPTTY_RPROMPT"
}

draw_prompts() {
  PROMPTTY_DATA_DIR="$(get_dir)"
  prompt_left
  prompt_right
}

draw_gap() {
  if [[ $_SHOW_GAP -eq 1 ]]; then
    if (( PROMPTTY_LAST_CMD_IS_CLEAR )); then
      PROMPTTY_DRAW_GAP=1
      PROMPTTY_LAST_CMD_IS_CLEAR=0
      return
    fi
    if (( PROMPTTY_IS_FIRST_PROMPT )); then
      PROMPTTY_IS_FIRST_PROMPT=0
      PROMPTTY_DRAW_GAP=1
      return
    fi
    if (( PROMPTTY_DRAW_GAP == 0 )); then
      if [[ -t 1 ]]; then
        if [[ $LINES -le 5 ]]; then
          :
        elif [[ ${PROMPTTY_HAS_DRAWN_GAP:-0} -eq 0 ]]; then
          :
        else
          print
        fi
      else
        print
      fi
      PROMPTTY_HAS_DRAWN_GAP=1
    else
      print
    fi
  fi
  PROMPTTY_DRAW_GAP=1
}

preexec_promptTy() {
  debug_log "preexec: command=$1"
  if [[ "$1" == "clear" || "$1" == "reset" ]]; then
    PROMPTTY_DRAW_GAP=0
    PROMPTTY_LAST_CMD_IS_CLEAR=1
  else
    PROMPTTY_LAST_CMD_IS_CLEAR=0
  fi

  if [[ -z "${1// }" ]]; then
    PROMPTTY_WAS_EMPTY=1
  else
    PROMPTTY_WAS_EMPTY=0
  fi

  PROMPTTY_RAW_TEXC=$EPOCHSECONDS
}

precmd_promptTy() {
  debug_log "precmd: PWD=$PWD"
  PROMPTTY_LAST_EXIT=$?
  PROMPTTY_DATA_TEXC="$(get_texc)"
  PROMPTTY_DATA_GITINFO="$(get_gitinfo "$PWD")"
  debug_log "precmd: git info result: ${PROMPTTY_DATA_GITINFO}"
  draw_gap
  draw_prompts
  PROMPTTY_RAW_TEXC=0
  PROMPTTY_WAS_EMPTY=0
}

main_promptTy() {
  setopt prompt_subst
  autoload -Uz add-zsh-hook
  (( $+EPOCHSECONDS )) || zmodload zsh/datetime

  debug_log "main_promptTy: initializing"
  
  PROMPTTY_IS_FIRST_PROMPT=1

  zle-line-init() { PROMPTTY_FIRST_PROMPT=1; zle reset-prompt; }
  zle -N zle-line-init

  add-zsh-hook preexec preexec_promptTy
  add-zsh-hook precmd precmd_promptTy
}

main_promptTy "$@"