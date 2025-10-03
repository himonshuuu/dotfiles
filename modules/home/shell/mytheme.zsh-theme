autoload -U colors && colors

GREEN="%{$fg_bold[green]%}"
RED="%{$fg_bold[red]%}"
YELLOW="%{$fg_bold[yellow]%}"
BLUE="%{$fg_bold[blue]%}"
MAGENTA="%{$fg_bold[magenta]%}"
CYAN="%{$fg_bold[cyan]%}"
RESET="%{$reset_color%}"

ICON_BRANCH="󰘬"
ICON_AHEAD="⇡"
ICON_BEHIND="⇣"
ICON_STAGED="*"
ICON_UNSTAGED="+"
ICON_UNTRACKED="?"
ICON_STASHED=""
ICON_CLEAN=""
ICON_VENV=""


function virtualenv_info() {
  if [[ -n "$VIRTUAL_ENV" ]]; then
    echo "${CYAN}${ICON_VENV} ${$(basename $VIRTUAL_ENV)//\%/%%}${RESET} "
  fi
}

function git_prompt_info() {
  [[ -d .git ]] || git rev-parse --git-dir > /dev/null 2>&1 || return

  local ref branch
  ref=$(git symbolic-ref HEAD 2> /dev/null) || ref=$(git rev-parse --short HEAD 2> /dev/null) || return
  branch=${ref#refs/heads/}

  local status_output
  status_output=$(git status --porcelain --branch 2>/dev/null)
  
  local ahead behind clean=1
  local output=""

  local branch_line
  branch_line=$(echo "$status_output" | head -1)
  if [[ $branch_line == *"ahead"* ]]; then
    ahead=$(echo "$branch_line" | sed -n 's/.*ahead \([0-9]\+\).*/\1/p')
  fi
  if [[ $branch_line == *"behind"* ]]; then
    behind=$(echo "$branch_line" | sed -n 's/.*behind \([0-9]\+\).*/\1/p')
  fi

  output+="${BLUE}${ICON_BRANCH} ${MAGENTA}${branch}${RESET} "

  [[ -n "$ahead" && "$ahead" != "0" ]] && { output+="${GREEN}${ICON_AHEAD}${ahead} "; clean=0; }
  [[ -n "$behind" && "$behind" != "0" ]] && { output+="${RED}${ICON_BEHIND}${behind} "; clean=0; }
  
  if [[ -n "$status_output" ]]; then
    echo "$status_output" | grep -q '^[MADRC]' && { output+="${YELLOW}${ICON_STAGED} "; clean=0; }
    echo "$status_output" | grep -q '^.[MD]' && { output+="${RED}${ICON_UNSTAGED} "; clean=0; }
    echo "$status_output" | grep -q '^??' && { output+="${CYAN}${ICON_UNTRACKED} "; clean=0; }
  fi
  
  [[ "$clean" = 0 ]] && git stash list | grep -q . 2>/dev/null && output+="${MAGENTA}${ICON_STASHED} "

  [[ "$clean" = 1 ]] && output+="${GREEN}${ICON_CLEAN} "

  echo -n "${output}${RESET}"
}

setopt prompt_subst

function build_prompt() {
    echo "${GREEN}%n${RESET}@${BLUE}%m${RESET} ${CYAN}%~${RESET} $(git_prompt_info)$(virtualenv_info)%k"
}

PROMPT='$(build_prompt)
%% '

function activate() {
    local venv_paths=(".venv/bin/activate" "venv/bin/activate" "env/bin/activate")
    for venv in $venv_paths; do
        if [[ -f "$venv" ]]; then
            source "$venv"
            return 0
        fi
    done
    echo "No virtual environment found in: ${venv_paths[*]}"
    return 1
}
function deactivate() {
    if [[ -n "$VIRTUAL_ENV" ]]; then
        builtin deactivate
    else
        echo "No virtual environment currently active"
        return 1
    fi
}