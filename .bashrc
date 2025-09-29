# -----------------------------------------------------------------------
if [ -x /opt/homebrew/bin/brew ]; then
  # Homebrew is in use.
  KXUE43_USE_BREW=1
fi
# ------------------------------------------------------------------------
# Idempotent PATH settings.
if [ -z "${KXUE43_SHELL_INIT+x}" ]; then
  export KXUE43_SHELL_INIT=1

  PATH="$HOME/go/bin:$HOME/.local/bin:$HOME/.pyenv/bin:/Applications/MacVim.app/Contents/bin:$PATH"

  if [ -z "${KXUE43_USE_BREW+x}" ]; then
    # No Homebrew means MacPorts is in use. Add it to PATH.
    PATH="/opt/local/bin:/opt/local/sbin:$PATH"
  fi
fi
# -----------------------------------------------------------------------
if [ -n "${KXUE43_USE_BREW+x}" ]; then
  # If Homebrew is in use, activate it.
  export HOMEBREW_FORBIDDEN_FORMULAE="openjdk"
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi
# -----------------------------------------------------------------------
# Activate pyenv.
eval "$(pyenv init -)"
# ------------------------------------------------------------------------
# Activate fnm.
if [ -z "${KXUE43_SHELL_INIT+x}" ]; then
  eval "$(fnm env --use-on-cd --shell bash)"
else
  # Trim the duplicate fnm item in the middle of PATH if exists.
  PATH=$(echo -n "$PATH" | tr ":" "\n" | grep -v "fnm_multishells" | tr "\n" ":" | sed 's/:$//')
  # Then activate fnm again, for the use-on-cd effect.
  eval "$(fnm env --use-on-cd --shell bash)"
fi
# ------------------------------------------------------------------------
# Use installed bash completions.
if [ -n "${KXUE43_USE_BREW+x}" ]; then
  # shellcheck disable=SC1091
  source /opt/homebrew/share/bash-completion/bash_completion
else
  # MacPorts.
  source /opt/local/share/bash-completion/bash_completion
fi
# ------------------------------------------------------------------------
# Enhance terminal prompt with Git info. This has nothing to do with Git completion.
# shellcheck disable=SC1090
source ~/.git-prompt.sh
PS1='\[\033[1m\]\[\033[36m\]\u@localhost:\[\033[34m\]\w\[\033[33m\]$(__git_ps1 " (%s)")\n$(if [[ $? == 0 ]]; then echo -e "\[\033[32m\]✔"; else echo -e "\[\033[31m\]✘"; fi)\[\033[0m\]\$ '
# ------------------------------------------------------------------------
# Key bindings.
# Use up/down arrow keys to search history based on current input.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# ------------------------------------------------------------------------
# View man pages in Vim
export MANPAGER="col -b | vim -c 'set ft=man' -MR - "
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
alias gmh='git log --oneline main..HEAD'
alias venvact='. .venv/bin/activate'
alias pea='eval $(poetry env activate)'
alias pue='poetry config --local virtualenvs.in-project true && poetry env use $(pyenv which python)'
alias ssp='python -c "import site;print(site.getsitepackages())"'
alias clean-aws-cache="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_CREDENTIAL_EXPIRATION && rm -rf ~/.aws/toolkit-cache && rm -rf ~/.aws/sso/cache && rm -rf ~/.aws/cli/cache && rm -rf ~/.aws/boto/cache"
alias clean-aws-env="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_REGION && unset AWS_DEFAULT_REGION && unset AWS_PROFILE && unset AWS_CREDENTIAL_EXPIRATION"
alias gci='aws sts get-caller-identity'
alias ls-path='printenv PATH | tr ":" "\n"'
alias gfpt='git fetch orgin --prune --prune-tags'
# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
# Source reused functions first.
if [ -r "$HOME/.fns.bashrc" ]; then
  source "$HOME/.fns.bashrc"
fi
# ------------------------------------------------------------------------
update-dot-files() {
  (
    # Make set -e not affecting parent shell.
    set -e

    pushd $HOME

    curl -o dot-files.zip -L https://github.com/kxue43/mac-dot-files/releases/latest/download/dot-files-nightly.zip
    unzip -o dot-files.zip
    rm dot-files.zip

    popd
  ) >/dev/null 2>&1
}
# ------------------------------------------------------------------------
rm-cdk-docker() {
  docker image rm "$(docker images --filter "reference=cdkasset-*:latest" --format "{{.Repository}}:{{.Tag}}")" &&
    docker image rm "$(docker images --filter "reference=*.amazonaws.com/cdk-hnb659fds-*:*" --format "{{.Repository}}:{{.Tag}}")"
}
# ------------------------------------------------------------------------
set-aws-region() {
  local region=

  if [ -n "${1:+x}" ]; then
    region=$1
  else
    region=$(_kxue43_prompt_aws_region $KXUE43_AWS_REGIONS)
  fi

  export AWS_DEFAULT_REGION=$region
  export AWS_REGION=$region
}
# ------------------------------------------------------------------------
ls-aws-env() {
  printenv | grep '^AWS'
}
# ------------------------------------------------------------------------
use-role-profile() {
  if [ -n "${1:+x}" ]; then
    export AWS_PROFILE=$1

    return 0
  fi

  AWS_PROFILE=$(_kxue43_prompt_aws_profile "$KXUE43_AWS_PROFILE_PREFIX")
  export AWS_PROFILE
}
# ------------------------------------------------------------------------
set-role-env() {
  local profile=

  if [ -n "${1:+x}" ]; then
    profile=$1
  else
    profile=$(_kxue43_prompt_aws_profile "$KXUE43_AWS_PROFILE_PREFIX")
  fi

  eval "$(aws configure export-credentials --format env --profile "$profile")"
  unset AWS_PROFILE
}
# ------------------------------------------------------------------------
glo() {
  git log --oneline "$@"
}
# ------------------------------------------------------------------------
gsh() {
  git show --name-only "$@"
}
# ------------------------------------------------------------------------
my-diff() {
  git diff --no-index "$1" "$2"
}
# ------------------------------------------------------------------------
code() {
  VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args "$@"
}
# ------------------------------------------------------------------------
ls-jdk() {
  /usr/libexec/java_home -V
}
# ------------------------------------------------------------------------
set-jdk() {
  local jdk_version

  jdk_version=$(_kxue43_prompt_jdk_version)

  JAVA_HOME=$(/usr/libexec/java_home -v "$jdk_version")
  export JAVA_HOME
}
# ------------------------------------------------------------------------
open-in-browser() {
  /usr/bin/python3 -m webbrowser -t $1
}
# ------------------------------------------------------------------------
gtc() {
  local profile=coverage.out
  go test -race -coverprofile=${profile} "${1:-./...}"
  go tool cover -html=${profile}
}
# ------------------------------------------------------------------------
count-fnm-symlinks() {
  if [ -d "$HOME/.local/state/fnm_multishells" ]; then
    find "$HOME/.local/state/fnm_multishells" -type l | wc -l
  fi
}
# ------------------------------------------------------------------------
# The following must be at the very end!!!
# ------------------------------------------------------------------------
# Source env-specific bashrc file if exists.
if [ -r "$HOME/.env.bashrc" ]; then
  source "$HOME/.env.bashrc"
fi
# ------------------------------------------------------------------------
