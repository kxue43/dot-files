# ------------------------------------------------------------------------
# PATH settings.
PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.pyenv/bin:/Applications/MacVim.app/Contents/bin:$PATH"
if type brew &>/dev/null; then
  if ! [[ -v BREW_PREFIX ]]; then
      eval $(/opt/homebrew/bin/brew shellenv)
  fi
  export HOMEBREW_FORBIDDEN_FORMULAE="openjdk"
else
  PATH="/opt/local/bin:/opt/local/sbin:$PATH"
fi
export PATH
# ------------------------------------------------------------------------
# Activate pyenv.
eval "$(pyenv init -)"
# ------------------------------------------------------------------------
# Java settings
#export JAVA_HOME=$(/usr/libexec/java_home -v <SET-HERE>)
# ------------------------------------------------------------------------
# Groovy settings
#export GROOVY_HOME=$HOME/.local/lib/groovy-<SET-HERE>
# ------------------------------------------------------------------------
