#!/usr/bin/env bash

main() {
  # Make necessary directories first.
  mkdir -p "$HOME/.newsboat"
  mkdir -p "$HOME/.w3m"

  local -a tracked=(
    .bash_logout
    .bash_profile
    .bashrc
    .fns.bashrc
    .kxue43.bashrc
    .gd.bashrc
    .gitconfig
    .gitconfig.personal
    .gvimrc
    .tmux.conf
    .vimrc
    .newsboat/config
    .newsboat/urls
    .w3m/config
    .w3m/keymap
    .w3m/bookmark.html
  )

  local name
  for name in "${tracked[@]}"; do
    # If the ln target already exists as a regular file, remove it.
    [ -f "$HOME/$name" ] && rm "$HOME/$name"

    # This is a no-ops if the target is already a symlink.
    ln -s "$HOME/.config/dot-files/$name" "$HOME/$name"
  done

  tracked=(decode-base64 fnm-links)

  local prefix="$HOME/.local/share/bash-completion/completions"

  mkdir -p "$prefix"

  for name in "${tracked[@]}"; do
    [ -f "$prefix/$name" ] && rm "$prefix/$name"

    ln -s "$HOME/.config/dot-files/completions/$name" "$prefix/$name"
  done

  tracked+=(sync-vim-packages)

  prefix="$HOME/.local/bin"

  mkdir -p "$prefix"

  for name in "${tracked[@]}"; do
    [ -f "$prefix/$name" ] && rm "$prefix/$name"

    ln -s "$HOME/.config/dot-files/bin/$name" "$prefix/$name"
  done

  if [ "$1" = "--with=untracked" ]; then
    mkdir -p "$HOME/.aws"

    [ -f "$HOME/.aws/config" ] && rm "$HOME/.aws/config"
    [ -f "$HOME/.aws/credentials" ] && rm "$HOME/.aws/credentials"

    cat >"$HOME/.aws/config" <<'EOF'
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

    cat >"$HOME/.aws/credentials" <<'EOF'
[AdminUser]
aws_access_key_id = 
aws_secret_access_key = 
EOF
  fi
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
