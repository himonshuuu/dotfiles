export PATH="$HOME/bin:$HOME/.local/bin:/usr/local/bin:$PATH"

export LANG=en_US.UTF-8
export ARCHFLAGS="-arch $(uname -m)"

if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='nvim'
fi

export PIP_REQUIRE_VIRTUALENV=false