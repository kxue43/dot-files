# ------------------------------------------------------------------------
# Idempotent PATH settings.
if [ -z ${KXUE43_SHELL_INIT+x} ]; then
  export KXUE43_SHELL_INIT=1

  PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.pyenv/bin:/Applications/MacVim.app/Contents/bin:$PATH"

  if ! [ -e /opt/homebrew/bin/brew -o -e /usr/local/bin/brew ]; then
    # No Homebrew means MacPorts is in use. Add it to PATH.
    PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  fi
  
  export PATH
fi
# -----------------------------------------------------------------------
if [ -e /opt/homebrew/bin/brew -o -e /usr/local/bin/brew ]; then
  # If Homebrew is in use, activate it.
  export HOMEBREW_FORBIDDEN_FORMULAE="openjdk"
  eval $(/opt/homebrew/bin/brew shellenv)
fi
# -----------------------------------------------------------------------
# Activate pyenv.
eval "$(pyenv init -)"
# ------------------------------------------------------------------------
# Java settings
#export JAVA_HOME=$(/usr/libexec/java_home -v <SET-HERE>)
# ------------------------------------------------------------------------
# Groovy settings
#export GROOVY_HOME=$HOME/.local/lib/groovy-<SET-HERE>
# ------------------------------------------------------------------------
# Activate fnm.
if [ -z ${KXUE43_SHELL_INIT+x} ]; then
  eval "$(fnm env --use-on-cd --shell bash)"
else
  # Trim the duplicate fnm item in the middle of PATH if exists.
  export PATH=$(echo -n $PATH | tr ":" "\n" | grep -v "fnm_multishells" | tr "\n" ":")
  # Then activate fnm again, for the use-on-cd effect.
  eval "$(fnm env --use-on-cd --shell bash)"
fi
# ------------------------------------------------------------------------
# Use installed bash completions.
if [ -e /opt/homebrew/bin/brew -o -e /usr/local/bin/brew ]; then
  source /opt/homebrew/share/bash-completion/bash_completion
else
  # No Homebrew means MacPorts is in use. Set FPATH for it.
  source /opt/local/share/bash-completion/bash_completion
fi
# ------------------------------------------------------------------------
# Enhance terminal prompt with Git info. This has nothing to do with Git completion.
source ~/.git-prompt.sh
PS1='\[\033[1m\]\[\033[36m\]\u@localhost:\[\033[34m\]\w\[\033[33m\]$(__git_ps1 " (%s)")\n$(if [[ $? == 0 ]]; then echo -e "\[\033[32m\]✔"; else echo -e "\[\033[31m\]✘"; fi)\[\033[0m\]\$ '
# ------------------------------------------------------------------------
# Key bindings.
# Use up/down arrow keys to search history based on current input.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------
alias gproj='cd ~/projects'
alias gtemp='cd ~/temp'
alias glearn='cd ~/learning'
alias gascd='cd ~/ascending'
alias gdump='cd ~/temp/dump'
alias rdump='pushd ~/temp ; rm -rf dump && mkdir dump ; popd'
alias glg-l='git log --graph --oneline --decorate-refs=refs/heads'
alias glg-lr='git log --graph --oneline --branches'
alias glg-a='git log --graph --oneline --all'
alias venvact='. .venv/bin/activate'
alias pea='eval $(poetry env activate)'
alias pue='poetry config --local virtualenvs.in-project true && poetry env use $(pyenv which python)'
alias ssp='python -c "import site;print(site.getsitepackages())"'
alias clean-aws-cache="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_CREDENTIAL_EXPIRATION && rm -rf ~/.aws/cli/cache && rm -rf ~/.aws/toolkit-cache"
alias clean-aws-env="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_REGION && unset AWS_DEFAULT_REGION && unset AWS_PROFILE && unset AWS_CREDENTIAL_EXPIRATION"
alias gs='git status'
alias gci='aws sts get-caller-identity'
alias ls-path='printenv PATH | tr ":" "\n"'
alias gfpt='git fetch orgin --prune --prune-tags'
alias gmh='git log --oneline main..HEAD'
# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
rm-cdk-docker() {
  docker image rm $(docker images --filter "reference=cdkasset-*:latest" --format "{{.Repository}}:{{.Tag}}") && \
  docker image rm $(docker images --filter "reference=*.amazonaws.com/cdk-hnb659fds-*:*" --format "{{.Repository}}:{{.Tag}}")
}
# ------------------------------------------------------------------------
set-aws-region() {
    export AWS_DEFAULT_REGION=${1:-us-east-1}
    export AWS_REGION=${1:-us-east-1}
}
# ------------------------------------------------------------------------
ls-aws-env() {
    printenv | grep AWS
}
# ------------------------------------------------------------------------
use-role-profile() {
    export AWS_PROFILE=${1:-CdkCliRole}
    aws sts get-caller-identity
}
# ------------------------------------------------------------------------
set-role-env() {
    eval $(aws configure export-credentials --format env --profile ${1:-CdkCliRole})
    unset AWS_PROFILE
}
# ------------------------------------------------------------------------
glo() {
    git log --oneline $@
}
# ------------------------------------------------------------------------
gsh() {
    git show --name-only $@
}
# ------------------------------------------------------------------------
my-diff() {
    git diff --no-index $1 $2
}
# ------------------------------------------------------------------------
code() {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}
# ------------------------------------------------------------------------
ls-jdk() {
    /usr/libexec/java_home -V
}
# ------------------------------------------------------------------------
gtc() {
    profile=coverage.out
    go test -coverprofile=${profile} ${1:-./...}
    go tool cover -html=${profile}
}
# ------------------------------------------------------------------------
