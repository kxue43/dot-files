---
author: Ke Xue
title: Debian 12 Desktop
date: 2025-10-27T13:41:19-04:00
draft: false
layout: docs
description: Set up a Debian 12 Linux desktop as developer machine.
tags:
- Linux
- dev machine
---

This document covers how to set up an x64 Debian 12 as a developer machine.
It is geared towards Go, Java, Python and JavaScript development.

All commands on this page should be executed from the user's home directory.

## Install Nvidia drivers.

Follow the steps on [Debian wiki](https://wiki.debian.org/NvidiaGraphicsDrivers).

Reboot.

## Install Flatpak and Flathub Firefox

Install Flatpak.

```bash
sudo apt install flatpak
```

If using Gnome Desktop.

```bash
sudo apt install gnome-software-plugin-flatpak
```

Add the Flathub repository.

```bash
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

Uninstall builtin Firefox.

```bash
sudo apt purge firefox-esr
```

Logout and login again. Install the Flathub version of Firefox.

## Install dash-to-dock

```bash
sudo apt install gnome-shell-extension-dashtodock
```

Logout and login again. Open the "Extensions" app. Turn on extensions and configure dash-to-dock.

## Install basic utilities

```bash
sudo apt install git curl jq
```

## Build NeoVim from source

Build the latest version available. The one in Debian 12 repository is too old.

Make sure the `nvim` binary is on `PATH`. Typically, it should be placed in `~/.local/bin`.

## Install `pyenv`

Install Python build dependencies.

```bash
sudo apt install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

Install `pyenv`.

```bash
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pushd ~/.pyenv && src/configure && make -C src && popd
```

## Install `pipx` and `poetry`

```bash
sudo apt install pipx
pipx ensure path
pipx install poetry
pipx inject poetry poetry-plugin-export
```

## Install `go`

Download Go installation archive (`.tar.gz` file) from official website.

```bash
export GO_VERSION=1.25.2

pushd ~/Downloads
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go${GO_VERSION}.linux-amd64.tar.gz
popd
```

## Install `fnm`

```bash
curl -fsSL https://fnm.vercel.app/install | bash
pushd ~/.local/bin; ln -s ~/.local/share/fnm/fnm ; popd
```

## Install AWS CLI v2

```bash
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o ~/Downloads/awscliv2.zip
pushd ~/Downloads
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip
popd
```

## Install GitHub CLI

```bash
(type -p wget >/dev/null || (sudo apt update && sudo apt install wget -y)) \
	&& sudo mkdir -p -m 755 /etc/apt/keyrings \
	&& out=$(mktemp) && wget -nv -O$out https://cli.github.com/packages/githubcli-archive-keyring.gpg \
	&& cat $out | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
	&& sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
	&& sudo mkdir -p -m 755 /etc/apt/sources.list.d \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& sudo apt update \
	&& sudo apt install gh -y
```

## Install `shellcheck`

```bash
sudo apt install shellcheck
```

## Install `rustup`

```bash
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

## Get dot files

```bash
mkdir -p ~/.config
git clone https://github.com/kxue43/dot-files ~/.config/dot-files
~/.config/dot-files/set-up.sh --with=untracked
```

Afterwards, edit the contents of `~/.env.bashrc`, `~/.aws/config` and `~/.aws/credentials` according to
the development environment (e.g. personal, work). These files are not symlinked and may contain
environment specific Bash functions/aliases or senstive information (e.g. local development tokens).

Restart the iTerm2 terminal so that Bash start-up files take effect.

## Set Git name and email for work environment (optional)

```bash
git config --file ~/.gitconfig.work user.name USER_NAME
git config --file ~/.gitconfig.work user.email EMAIL
```

## Install Go executables

```bash
go install github.com/kxue43/cli-toolkit/cmd/toolkit@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-assume-role@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-serve-static@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-show-md@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

## Set up NeoVim

```bash
git clone https://github.com/kxue43/nvim-files ~/.config/nvim && nvim
```

After plugin installation finishes, run `:MasonInstallAll` to install all LSPs.

Run `:checkhealth` to see if there are any problems.

## Install Amazon Corretto Java

```bash
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list
sudo apt-get update; sudo apt-get install -y java-21-amazon-corretto-jdk
```

Use the following command to manage activate Java version.

```bash
sudo update-alternatives --config java
```

## Install Maven and Gradle

Manually install Maven and Gradle. Set their desired version numbers first.

Packages are installed in `~/.local/lib`. Symlinks to the binaries are created in `~/.local/bin`.

```bash
export MVN_VERSION=3.9.11
export GRADLE_VERSION=9.1.0

curl -o ~/Downloads/apache-maven-${MVN_VERSION}-bin.zip -L https://dlcdn.apache.org/maven/maven-3/${MVN_VERSION}/binaries/apache-maven-${MVN_VERSION}-bin.zip
unzip -d ~/.local/lib ~/Downloads/apache-maven-${MVN_VERSION}-bin.zip
pushd ~/.local/bin && \
ls ~/.local/lib/apache-maven-${MVN_VERSION}/bin | xargs -I % sh -c "ln -s $HOME/.local/lib/apache-maven-${MVN_VERSION}/bin/%" && \
popd

curl -o ~/Downloads/gradle-${GRADLE_VERSION}-bin.zip -L https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip
unzip -d ~/.local/lib ~/Downloads/gradle-${GRADLE_VERSION}-bin.zip
pushd ~/.local/bin && \
ln -s $HOME/.local/lib/gradle-${GRADLE_VERSION}/bin/gradle && \
popd

rm ~/Downloads/apache-maven-${MVN_VERSION}-bin.zip 
rm ~/Downloads/gradle-${GRADLE_VERSION}-bin.zip
```

## Install Groovy (optional)

Download a Groovy _SDK bundle_ into the `~/Downloads` folder, e.g. use [this link](https://groovy.apache.org/download.html).
Set the `GROOVY_VERSION` environment variable below to the corresponding version.

```bash
export GROOVY_VERSION=5.0.1

unzip -d ~/.local/lib ~/Downloads/apache-groovy-sdk-${GROOVY_VERSION}.zip
pushd ~/.local/bin && \
ls ~/.local/lib/groovy-${GROOVY_VERSION}/bin | grep -v '\.bat$' | grep -v '\.ico$' | xargs -I % sh -c "ln -s $HOME/.local/lib/groovy-${GROOVY_VERSION}/bin/%" && \
popd

rm ~/Downloads/apache-groovy-sdk-${GROOVY_VERSION}.zip
```
