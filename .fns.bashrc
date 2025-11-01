# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
_kxue43_prompt() {
  local chosen

  select chosen in "$@"; do
    echo "Chose $chosen." >&2

    break
  done

  echo "$chosen"
}
# ------------------------------------------------------------------------
_kxue43_prompt_aws_profile() {
  local -a profiles

  mapfile -t profiles < <(grep "^\[profile $1" ~/.aws/config)

  profiles=("${profiles[@]/#\[profile /}")

  profiles=("${profiles[@]/%\]/}")

  _kxue43_prompt "${profiles[@]}"
}
# ------------------------------------------------------------------------
_kxue43_prompt_aws_region() {
  local -a regions

  if [ -z "${1:+x}" ]; then
    regions=(us-east-1 us-west-2)
  else
    mapfile -t -d : regions <<<"$1"
  fi

  _kxue43_prompt "${regions[@]}"
}
# ------------------------------------------------------------------------
_kxue43_prompt_jdk_version() {
  local -a versions

  mapfile -t versions < <(/usr/libexec/java_home -V 2>&1 | grep -Eo "^\s*\d+\.\d+\.\d+" | awk '{print $1}')

  _kxue43_prompt "${versions[@]}"
}
# ------------------------------------------------------------------------
_kxue43_set_path() {
  # For idempotency.
  if [ -z "${KXUE43_SHELL_INIT+x}" ]; then
    export KXUE43_SHELL_INIT=1

    local own_path="$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.pyenv/bin"

    if [ "$(uname -s)" = "Linux" ]; then
      own_path+=":/usr/local/go/bin"
    fi

    PATH="$own_path:$PATH"

    if [ -x /opt/local/bin/port ]; then
      # MacPorts is in use.
      # Until MacPorts provides Tcl 9.0, put /usr/local/bin in front of
      # MacPorts bin directories so that the self-built tclsh is used.
      PATH="/usr/local/bin:/opt/local/bin:/opt/local/sbin:$PATH"
    elif [ -x /opt/homebrew/bin/brew ]; then
      # Homebrew is in use.
      export HOMEBREW_FORBIDDEN_FORMULAE="openjdk"

      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
}
# ------------------------------------------------------------------------
_kxue43_enable_completion() {
  if [ -x /opt/homebrew/bin/brew ] && [ -r /opt/homebrew/share/bash-completion/bash_completion ]; then
    # Homebrew.
    # shellcheck disable=SC1091
    source /opt/homebrew/share/bash-completion/bash_completion
  elif [ -x /opt/local/bin/port ] && [ -r /opt/local/share/bash-completion/bash_completion ]; then
    # MacPorts.
    # shellcheck disable=SC1091
    source /opt/local/share/bash-completion/bash_completion
  elif [ "$(uname -s)" = "Linux" ]; then
    if [ -r /usr/share/bash-completion/bash_completion ]; then
      # shellcheck disable=SC1091
      source /usr/share/bash-completion/bash_completion
    elif [ -r /etc/bash_completion ]; then
      # shellcheck disable=SC1091
      source /etc/bash_completion
    fi
  fi
}
# ------------------------------------------------------------------------
_kxue43_activate_fnm() {
  if [ -z "${KXUE43_SHELL_INIT+x}" ]; then
    eval "$(fnm env --use-on-cd --shell bash)"
  else
    # Trim the duplicate fnm item in the middle of PATH if exists.
    PATH=$(echo -n "$PATH" | tr ":" "\n" | grep -v "fnm_multishells" | tr "\n" ":" | sed 's/:$//')

    # Then activate fnm again, for the use-on-cd effect.
    eval "$(fnm env --use-on-cd --shell bash)"
  fi
}
# ------------------------------------------------------------------------
_kxue43_source_env_bashrc() {
  local prefix

  case "$(hostname)" in
  MacBookAir.fios-router.home)
    prefix=kxue43
    ;;
  LM-*)
    prefix=gd
    ;;
  *)
    prefix="env"
    ;;
  esac

  # shellcheck disable=SC1090
  [ -r "$HOME/.${prefix}.bashrc" ] && source "$HOME/.${prefix}.bashrc"
}
# ------------------------------------------------------------------------
_kxue43_color_echo() {
  local eol="\n"
  if [ "$1" = "-n" ]; then
    eol=

    shift
  fi

  local code

  case "$1" in
  red)
    code=31
    ;;
  green)
    code=32
    ;;
  yellow)
    code=33
    ;;
  blue)
    code=34
    ;;
  magenta)
    code=35
    ;;
  cyan)
    code=36
    ;;
  *)
    code=37
    ;;
  esac

  printf "\033[${code}m%s\033[0m${eol}" "$2"
}
# ------------------------------------------------------------------------
