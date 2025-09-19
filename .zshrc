# ------------------------------------------------------------------------
# Enhance terminal prompt with Git info. This has nothing to do with Git completion.
source ~/.git-prompt.sh
setopt PROMPT_SUBST ; PS1=$'%B%F{cyan}%n@localhost:%F{12}%~%F{11} $(__git_ps1 "(%s)")\n%(?.%F{10}\U2714.%F{9}\U2718)%b%f\$ '
# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------
alias gproj='cd ~/projects'
alias gtemp='cd ~/temp'
alias glearn='cd ~/learning'
alias gascd='cd ~/ascending'
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
# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
function rm-cdk-docker {
  docker image rm $(docker images --filter "reference=cdkasset-*:latest" --format "{{.Repository}}:{{.Tag}}") && \
  docker image rm $(docker images --filter "reference=*.amazonaws.com/cdk-hnb659fds-*:*" --format "{{.Repository}}:{{.Tag}}")
}
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