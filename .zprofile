# ------------------------------------------------------------------------
# Activate brew on Apple ARM machines.
eval $(/opt/homebrew/bin/brew shellenv)
# ------------------------------------------------------------------------
# PATH.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$HOME/.local/bin:$PATH"
# ------------------------------------------------------------------------
# Activate pyenv.
eval "$(pyenv init -)"
# ------------------------------------------------------------------------
# Use installed zsh completions.
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi
# ------------------------------------------------------------------------
