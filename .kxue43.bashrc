# ------------------------------------------------------------------------
# Environment variables.
# ------------------------------------------------------------------------
# Source credentials from untracked file if exists.
# shellcheck disable=SC1091
[ -r "$HOME/.creds.bashrc" ] && source "$HOME/.creds.bashrc"

# Java settings.
JAVA_HOME=$(/usr/libexec/java_home -v 21)
export JAVA_HOME

# Groovy settings.
GROOVY_HOME=$HOME/.local/lib/groovy-4.0.27
export GROOVY_HOME
# ------------------------------------------------------------------------
# Aliases.
# ------------------------------------------------------------------------
alias gs='git status'
# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
