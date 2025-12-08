#!/usr/bin/env bash

set -eu -o pipefail

printf "\033[36m%s\033[0m\n" "Installing the development-tools group."
sudo dnf group install -y development-tools

printf "\033[36m%s\033[0m\n" "Installing essential utilities."
sudo dnf install -y rlwrap jq

printf "\033[36m%s\033[0m\n" "Installing coding tools."
sudo dnf install -y vim-enhanced neovim ripgrep luarocks tmux pre-commit

printf "\033[36m%s\033[0m\n" "Installing Go."
sudo dnf install -y golang

printf "\033[36m%s\033[0m\n" "Installing rustup."
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

printf "\033[36m%s\033[0m\n" "Installing fnm."
export PATH="$HOME/.cargo/bin:$PATH"
cargo install fnm

printf "\033[36m%s\033[0m\n" "Installing AWS CLI v2."
sudo dnf install -y awscli2

printf "\033[36m%s\033[0m\n" "Installing GitHub CLI."
sudo dnf install -y gh

printf "\033[36m%s\033[0m\n" "Installing shellcheck."
sudo dnf install -y shellcheck

printf "\033[36m%s\033[0m\n" "Installing CLI tools written in Go."
go install github.com/kxue43/cli-toolkit/cmd/toolkit@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-assume-role@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-serve-static@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-show-md@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
go install golang.org/x/tools/cmd/godoc@latest
go install github.com/air-verse/air@latest

printf "\033[36m%s\033[0m\n" "Remember to run $HOME/.config/dot-files/set-up.sh to create symlinks."
