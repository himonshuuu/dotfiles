if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  eval "$(ssh-agent -s)" > /dev/null 2>&1 
fi

ssh-add -q ${HOME}/ssh-keys/github 2>/dev/null
