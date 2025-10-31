# -----------------------------------------------------------------------
# Source reused functions first.
[ -r "$HOME/.fns.bashrc" ] && source "$HOME/.fns.bashrc"
# ------------------------------------------------------------------------
# Idempotent PATH settings.
_kxue43_set_path
# -----------------------------------------------------------------------
# Activate pyenv.
eval "$(pyenv init -)"
# ------------------------------------------------------------------------
# Activate fnm.
_kxue43_activate_fnm
# ------------------------------------------------------------------------
_kxue43_enable_completion
# ------------------------------------------------------------------------
# Enhance terminal prompt with Git info. This has nothing to do with Git completion.
# shellcheck disable=SC1090
source ~/.git-prompt.sh
PS1='\[\033[94m\]\u@\t: \[\033[96m\]\w\[\033[93m\]$(__git_ps1 " (%s)")\n$(if [ $? -eq 0 ]; then echo -e "\[\033[92m\]\U2714"; else echo -e "\[\033[91m\]\U2718"; fi)\[\033[0m\]\$ '
# ------------------------------------------------------------------------
# Key bindings.
# Use up/down arrow keys to search history based on current input.
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
# ------------------------------------------------------------------------
# View man pages in NeoVim
export MANPAGER="sh -c 'col -b -x | nvim -c \"set ft=man nonu nomodifiable\" -R - '"
# The MANPAGER above only works with backspace-based formatting,
# not with the more modern ANSI escape codes. macOS only uses
# backspace-based formatting. On Linux, we need to set GROFF_NO_SGR
# to force it.
[ "$(uname -s)" = "Linux" ] && export GROFF_NO_SGR=1
# ------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------
alias ls='ls --color=auto'
alias awk='gawk'
alias gproj='cd ~/projects'
alias gtemp='cd ~/temp'
alias glearn='cd ~/learning'
alias gascd='cd ~/ascending'
alias gdump='cd ~/temp/dump'
alias rdump='pushd ~/temp ; rm -rf dump && mkdir dump ; popd'
alias venvact='. .venv/bin/activate'
alias pea='eval $(poetry env activate)'
alias pue='poetry config --local virtualenvs.in-project true && poetry env use $(pyenv which python)'
alias ssp='python -c "import site;print(site.getsitepackages())"'
alias clean-aws-cache="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_CREDENTIAL_EXPIRATION && rm -rf ~/.aws/toolkit-cache && rm -rf ~/.aws/sso/cache && rm -rf ~/.aws/cli/cache && rm -rf ~/.aws/boto/cache"
alias clean-aws-env="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && unset AWS_REGION && unset AWS_DEFAULT_REGION && unset AWS_PROFILE && unset AWS_CREDENTIAL_EXPIRATION"
alias gci='aws sts get-caller-identity'
alias ls-path='printenv PATH | tr ":" "\n"'
alias nvconfp='pushd ~/.config/nvim ; git pull ; popd'
alias dotfp='pushd ~/.config/dot-files ; git pull ; popd'
# ------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------
tl() {
  tmux list-sessions -F '#{session_name} (#{@long-name}): #{session_windows}win'
}
# ------------------------------------------------------------------------
tn() {
  if (($# != 2)); then
    _kxue43_color_echo red "Need two positional arguments, but got ${#}: ${*}."

    return 1
  fi

  tmux new-session -d -s "$1"
  tmux set-option -t "$1" @long-name "$2"
  tmux attach-session -t "$1"
}
# ------------------------------------------------------------------------
ta() {
  tmux attach-session -t "$1"
}
# ------------------------------------------------------------------------
rm-cdk-docker() {
  docker image rm "$(docker images --filter "reference=cdkasset-*:latest" --format "{{.Repository}}:{{.Tag}}")" &&
    docker image rm "$(docker images --filter "reference=*.amazonaws.com/cdk-hnb659fds-*:*" --format "{{.Repository}}:{{.Tag}}")"
}
# ------------------------------------------------------------------------
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
  local profile

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
  /usr/bin/python3 -m webbrowser -t "$1"
}
# ------------------------------------------------------------------------
gtc() {
  local profile=coverage.out

  go test -race -coverprofile=${profile} "${1:-./...}"

  go tool cover -html=${profile}
}
# ------------------------------------------------------------------------
clean-up-fnm-symlinks() {
  if ! [ "$(uname -s)" = "Darwin" ]; then
    _kxue43_color_echo red "Only use this function on macOS."

    return 1
  fi

  local nod="${1:-3}"

  if [ -n "${FNM_MULTISHELL_PATH:+x}" ]; then
    _kxue43_color_echo cyan "Cleaning up the $HOME/.local/state/fnm_multishells directory of symlinks older than ${nod} day(s)."

    find "$(dirname "${FNM_MULTISHELL_PATH}")/" -type l -name '*_*' -mtime "+${nod}d" -exec rm {} +
  fi
}
# ------------------------------------------------------------------------
count-fnm-symlinks() {
  local fnm_multishell_dir
  fnm_multishell_dir="$(dirname "$FNM_MULTISHELL_PATH"/)"

  [ -d "$fnm_multishell_dir" ] && find "$fnm_multishell_dir" -type l | wc -l
}
# ------------------------------------------------------------------------
sync-vim-packages() {
  local repos=(
    morhetz/gruvbox
    preservim/nerdtree
    vim-airline/vim-airline
    vim-airline/vim-airline-themes
  )

  local url repo dir name

  for repo in "${repos[@]}"; do
    url="https://github.com/$repo"

    name=$(basename "$url")

    dir="$HOME/.vim/pack/$name/start/$name/"

    if [ -d "$dir" ]; then
      pushd "$dir" || return 1
      git pull --no-tags
      popd || return 1
    else
      mkdir -p "$dir"
      git clone --depth 1 "$url" "$dir"
    fi
  done
}
# ------------------------------------------------------------------------
decode-base64() {
  local tee=n
  local -i size=1048576

  local opt OPTIND OPTARG

  while getopts ":hts:" opt; do
    case $opt in
    h)
      cat <<EOF
USAGE: ${FUNCNAME[0]} [-h] [-t] [-s BUFFER_SIZE] [FILE]

Read a base64 encoded blob from stdin, decode it and write the output to FILE.

If FILE is not provided, echo output to stdout. To both write to FILE and echo to
stdout, use the -t option.

If there is no piping or redirection to stdin, prompt for input.

OPTIONS:
    -h                Show this help message
    -t                Echo decoded JSON to stdout
    -s BUFFER_SIZE    Buffer size in MB for holding the input blob.
                      Must be an integer. Defaults to 1. Only necessary for
                      very large input blob in interactive mode.
EOF

      return 0
      ;;
    t)
      tee=y
      ;;
    s)
      size=$((size * OPTARG))
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2

      return 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2

      return 1
      ;;
    esac
  done

  shift $((OPTIND - 1))

  if (($# > 1)); then
    echo "Expects at most one positional argument, but $# was given."

    return 1
  fi

  local blob input

  if [[ -t 0 ]]; then
    read -r -n "$size" -p "Paste in the blob: " blob
    input="<<<'$blob'"
  else
    input=" <&0"
  fi

  # $blob is single-quoted in $input, so only $1 below is subject to
  # command injection. Since this is for own use, choose the eval
  # solution instead of writing more conditional code.
  local command
  if (($# == 1)) && [[ $tee == "y" ]]; then
    command="base64 -d $input | jq '.' | tee $1"
  elif (($# == 1)); then
    command="base64 -d $input | jq '.' >$1"
  else
    command="base64 -d $input | jq '.'"
  fi

  eval "$command"
}
# ------------------------------------------------------------------------
# The following must be at the very end!!!

# Source env-specific bashrc file if exists.
_kxue_source_env_bashrc
# ------------------------------------------------------------------------
