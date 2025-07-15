# ------------------------------------------------------------------------
# brew settings
# Activate brew on Apple ARM machines.
if ! [[ -v BREW_PREFIX ]]; then
    eval $(/opt/homebrew/bin/brew shellenv)
fi
export HOMEBREW_FORBIDDEN_FORMULAE="openjdk awscli"
# ------------------------------------------------------------------------
# PATH.
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$HOME/go/bin:$PYENV_ROOT/bin:$HOME/.local/bin:/Applications/MacVim.app/Contents/bin:$PATH"
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
# Enhance terminal prompt with Git info. This has nothing to do with Git completion.
source ~/.git-prompt.sh
setopt PROMPT_SUBST ; PS1=$'%B%F{cyan}%n@localhost:%F{12}%~%F{11} $(__git_ps1 "(%s)")\n%(?.%F{10}\U2714.%F{9}\U2718)%b%f\$ '
# ------------------------------------------------------------------------
# Use installed zsh completions.
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi
# ------------------------------------------------------------------------
# Activate zsh-autosuggestions.
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept
# ------------------------------------------------------------------------
# Activate fnm - doesn't cause a slow down as nvm.
eval "$(fnm env --use-on-cd --shell zsh)"
# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------
alias gproj='cd ~/projects'
alias gtemp='cd ~/temp'
alias glearn='cd ~/learning'
alias gascd='cd ~/ascending'
alias glg='git log --graph --oneline --all'
alias venvact='. .venv/bin/activate'
alias clean-aws-cache="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_CREDENTIAL_EXPIRATION && rm -rf ~/.aws/cli/cache && rm -rf ~/.aws/toolkit-cache"
alias clean-aws-env="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_REGION && unset AWS_DEFAULT_REGION && unset AWS_PROFILE && unset AWS_CREDENTIAL_EXPIRATION"
alias gs='git status'
alias gci='aws sts get-caller-identity'
# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
function set-aws-region {
    export AWS_DEFAULT_REGION=${1:-us-east-1}
    export AWS_REGION=${1:-us-east-1}
}
# ------------------------------------------------------------------------
function ls-aws-env {
    printenv | grep AWS
}
# ------------------------------------------------------------------------
function use-role-profile {
    export AWS_PROFILE=${1:-CdkCliRole}
    aws sts get-caller-identity
}
# ------------------------------------------------------------------------
function set-role-env {
    eval $(aws configure export-credentials --format env --profile ${1:-CdkCliRole})
    unset AWS_PROFILE
}
# ------------------------------------------------------------------------
function glo {
    git log --oneline $@
}
# ------------------------------------------------------------------------
function gsh {
    git show --name-only $@
}
# ------------------------------------------------------------------------
function my-diff {
    git diff --no-index $1 $2
}
# ------------------------------------------------------------------------
function code {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}
# ------------------------------------------------------------------------
function ls-jdk {
    /usr/libexec/java_home -V
}
# ------------------------------------------------------------------------
function gtc {
    profile=coverage.out
    go test -coverprofile=${profile} ${1:-./...}
    go tool cover -html=${profile}
}
# ------------------------------------------------------------------------