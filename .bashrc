# -----------------------------------------------------------------------
# Source private functions.
source "$HOME/.fns.bashrc"
# -----------------------------------------------------------------------
_kxue43_set_path

eval "$(pyenv init -)"

_kxue43_activate_fnm

_kxue43_enable_completion

_kxue43_set_man_pager
# ------------------------------------------------------------------------
# Bash key bindings.
# Use up/down arrow keys to search history based on current input.
bind '"\e[A": previous-history'
bind '"\e[B": next-history'
bind '"\C-p": history-search-backward'
bind '"\C-n": history-search-forward'
# ------------------------------------------------------------------------
# Aliases

alias ls='ls --color=auto'
alias gproj='cd ~/projects'
alias gtemp='cd ~/temp'
alias glearn='cd ~/learning'
alias gascd='cd ~/ascending'
alias gdump='cd ~/temp/dump'
alias rdump='pushd ~/temp >/dev/null ; rm -rf dump && mkdir dump ; popd >/dev/null'
alias venvact='. .venv/bin/activate'
alias pea='eval $(poetry env activate)'
alias pue='poetry config --local virtualenvs.in-project true && poetry env use $(pyenv which python)'
alias ssp='python -c "import site;print(site.getsitepackages())"'
alias clean-aws-cache="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_CREDENTIAL_EXPIRATION && rm -rf ~/.aws/toolkit-cache && rm -rf ~/.aws/sso/cache && rm -rf ~/.aws/cli/cache && rm -rf ~/.aws/boto/cache"
alias clean-aws-env="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_REGION && unset AWS_DEFAULT_REGION && unset AWS_PROFILE && unset AWS_CREDENTIAL_EXPIRATION"
alias gci='aws sts get-caller-identity'
alias ls-path='printenv PATH | tr ":" "\n"'
alias nvconfp='pushd ~/.config/nvim >/dev/null ; git pull ; popd >/dev/null'
alias dotfp='pushd ~/.config/dot-files >/dev/null ; git pull ; popd >/dev/null'
# ------------------------------------------------------------------------
# Functions

tl() {
  tmux list-sessions -F '#{session_name}: #{session_windows}win'
}

set-aws-region() {
  local region

  if [ -n "${1:+x}" ]; then
    region=$1
  else
    region=$(_kxue43_prompt_aws_region "$KXUE43_AWS_REGIONS")
  fi

  export AWS_DEFAULT_REGION=$region

  export AWS_REGION=$region
}

ls-aws-env() {
  printenv | grep '^AWS'
}

use-role-profile() {
  if [ -n "${1:+x}" ]; then
    export AWS_PROFILE=$1

    return 0
  fi

  AWS_PROFILE=$(_kxue43_prompt_aws_profile "$KXUE43_AWS_PROFILE_PREFIX")
  export AWS_PROFILE
}

set-role-env() {
  local profile

  if [ -n "${1:+x}" ]; then
    profile=$1
  else
    profile=$(_kxue43_prompt_aws_profile "$KXUE43_AWS_PROFILE_PREFIX")
  fi

  eval "$(aws configure export-credentials --format env --profile "$profile")"

  unset AWS_PROFILE
}

glo() {
  git log --oneline "$@"
}

gsh() {
  git show --name-only "$@"
}

my-diff() {
  git diff --no-index "$1" "$2"
}

gtc() {
  local profile=coverage.out

  go test -race -coverprofile=${profile} "${1:-./...}"

  go tool cover -html=${profile}
}

if [ "$(uname -s)" = "Darwin" ]; then
  ls-jdk() {
    /usr/libexec/java_home -V
  }

  set-jdk() {
    local jdk_version

    jdk_version=$(_kxue43_prompt_jdk_version)

    JAVA_HOME=$(/usr/libexec/java_home -v "$jdk_version")
    export JAVA_HOME
  }

  rm-cdk-docker() {
    docker image rm "$(docker images --filter "reference=cdkasset-*:latest" --format "{{.Repository}}:{{.Tag}}")" &&
      docker image rm "$(docker images --filter "reference=*.amazonaws.com/cdk-hnb659fds-*:*" --format "{{.Repository}}:{{.Tag}}")"
  }

  show-img() {
    if [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
      echo "Only works on iTerm2."

      return 1
    fi

    echo -e "\033]1337;File=inline=1:$(base64 <"$1")\a"
  }
fi
# ------------------------------------------------------------------------
# Source env-specific bashrc file.
_kxue43_source_env_bashrc
# ------------------------------------------------------------------------
