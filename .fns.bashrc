# Reusable private functions.

_kxue43_prompt() {
  local chosen

  select chosen in "$@"; do
    echo "Chose $chosen." >&2

    break
  done

  echo "$chosen"
}

_kxue43_prompt_aws_profile() {
  local -a profiles

  mapfile -t profiles < <(grep "^\[profile $1" ~/.aws/config)

  profiles=("${profiles[@]/#\[profile /}")

  profiles=("${profiles[@]/%\]/}")

  _kxue43_prompt "${profiles[@]}"
}

_kxue43_prompt_aws_region() {
  local -a regions

  if [ -z "${1:+x}" ]; then
    regions=(us-east-1 us-west-2)
  else
    mapfile -t -d : regions <<<"$1"
  fi

  _kxue43_prompt "${regions[@]}"
}

# Only works on macOS.
_kxue43_prompt_jdk_version() {
  local -a versions

  mapfile -t versions < <(/usr/libexec/java_home -V 2>&1 | grep -Eo "^\s*\d+\.\d+\.\d+" | awk '{print $1}')

  _kxue43_prompt "${versions[@]}"
}

_kxue43_set_path() {
  # For idempotency.
  if [ -z "${KXUE43_SHELL_INIT+x}" ]; then
    export KXUE43_SHELL_INIT=1

    local own_path="$HOME/go/bin:$HOME/.cargo/bin:$HOME/.local/bin:$HOME/.pyenv/bin"

    PATH="$own_path:$PATH"

    if [ -x /opt/local/bin/port ]; then
      PATH="/opt/local/bin:/opt/local/sbin:$PATH"
    elif [ -x /opt/homebrew/bin/brew ]; then
      export HOMEBREW_FORBIDDEN_FORMULAE="openjdk"

      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
  fi
}

_kxue43_enable_completion() {
  if [ -x /opt/homebrew/bin/brew ]; then
    source /opt/homebrew/etc/profile.d/bash_completion.sh

    source /opt/homebrew/etc/bash_completion.d/git-prompt.sh
  elif [ -x /opt/local/bin/port ]; then
    source /opt/local/etc/profile.d/bash_completion.sh

    source /opt/local/share/git/git-prompt.sh

    # Turn on completion manually for AWS CLI because it's not installed by port.
    complete -C '/usr/local/bin/aws_completer' aws
  elif [ "$(hostname)" = "toolbx" ] || [ "$(hostname)" = "fedora" ]; then
    # On Fedora, scripts in `/etc/profile.d` are automatically sourced, which includes `bash_completion.sh`.

    source /usr/share/git-core/contrib/completion/git-prompt.sh
  fi

  PS1='\[\033[94m\]\u@\t: \[\033[96m\]\w\[\033[93m\]$(__git_ps1 " (%s)")\n$(if [ $? -eq 0 ]; then echo -e "\[\033[92m\]\U2714"; else echo -e "\[\033[91m\]\U2718"; fi)\[\033[0m\]\$ '
}

_kxue43_activate_fnm() {
  if [ -z "${KXUE43_SHELL_INIT+x}" ]; then
    eval "$(fnm env --use-on-cd --shell bash)"
  else
    # Trim the duplicate fnm item in the middle of PATH if exists.
    PATH=$(sed -E -e 's/:[^:]+fnm_multishells[^:]+//' -e 's/[^:]+fnm_multishells[^:]+://' <<<"$PATH")

    # Then activate fnm again, for the use-on-cd effect.
    eval "$(fnm env --use-on-cd --shell bash)"
  fi
}

_kxue43_set_man_pager() {
  export MANPAGER="sh -c 'col -b -x | nvim -c \"set ft=man nonu nomodifiable\" -R - '"

  if [ "$(hostname)" = "fedora" ]; then
    # Fedora Silverblue host OS doesn't have NeoVim.
    MANPAGER="sh -c 'col -b -x | vim -c \"set ft=man nonu nomodifiable\" -R - '"
  fi

  # The MANPAGER above only works with backspace-based formatting,
  # not with the more modern ANSI escape codes. macOS only uses
  # backspace-based formatting. On Linux, we need to set GROFF_NO_SGR
  # to force it.
  [ "$(uname -s)" = "Linux" ] && export GROFF_NO_SGR=1
}

_kxue43_source_env_bashrc() {
  local prefix

  case "$(hostname)" in
  MacBookAir.fios-router.home | fedora | toolbx)
    prefix=kxue43
    ;;
  LM-*)
    prefix=gd
    ;;
  *)
    prefix="env"
    ;;
  esac

  source "$HOME/.${prefix}.bashrc"
}
