#!/usr/bin/env bash

main() {
  local -a tracked=(
    .bash_logout
    .bash_profile
    .bashrc
    .fns.bashrc
    .gitconfig
    .gitconfig-personal
    .gvimrc
    .tmux.conf
    .vimrc
  )

  local name
  for name in "${tracked[@]}"; do
    [ -f "$HOME/$name" ] && rm "$HOME/$name"

    ln -s "$HOME/.config/dot-files/$name" "$HOME/$name"
  done

  if [ "$1" = "--with=untracked" ]; then
    mkdir -p "$HOME/.aws"

    [ -f "$HOME/.aws/config" ] && rm "$HOME/.aws/config"
    [ -f "$HOME/.aws/credentials" ] && rm "$HOME/.aws/credentials"

    cat >"$HOME/.aws/config" <<EOF
[default]
output = json

[profile AdminUser]
output = json

[profile AdminRole]
output = json
credential_process = toolkit-assume-role --mfa-serial arn:aws:iam::572941611575:mfa/AdminUser --profile AdminUser --duration-seconds 7200 arn:aws:iam::572941611575:role/AdminRole

[profile CdkCliRole]
output = json
credential_process = toolkit-assume-role --mfa-serial arn:aws:iam::572941611575:mfa/AdminUser --profile AdminUser --duration-seconds 7200 arn:aws:iam::572941611575:role/CdkCliRole
EOF

    cat >"$HOME/.aws/credentials" <<EOF
[AdminUser]
aws_access_key_id = 
aws_secret_access_key = 
EOF

    [ -f "$HOME/.env.bashrc" ] && rm "$HOME/.env.bashrc"

    cat >"$HOME/.env.bashrc" <<EOF
# ------------------------------------------------------------------------
# Environment variables.
# ------------------------------------------------------------------------
# Java settings
# JAVA_HOME=$(/usr/libexec/java_home -v SET_HERE)
# export JAVA_HOME

# Groovy settings
# export GROOVY_HOME="$HOME/.local/lib/groovy-SET_HERE"
# ------------------------------------------------------------------------
# Aliases.
# ------------------------------------------------------------------------
# alias gs='git status'
# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
EOF
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
