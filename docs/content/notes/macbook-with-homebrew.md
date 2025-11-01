---
author: Ke Xue
title: MacBook with Homebrew
date: 2025-10-27T13:36:55-04:00
draft: false
layout: docs
description: Set up an ARM-chip MacBook as developer machine using Homebrew as package manager.
tags:
- macOS
- dev machine
---

## Introduction

This document covers how to set up an ARM64 Macbook as a developer machine.
It is geared towards Go, Java, Python and JavaScript development.

All commands on this page should be executed from the user's home directory.

For using MacPorts instead of Homebrew as the package manager, refer to [MacBook with MacPorts]({{% ref "/notes/macbook-with-macports" %}}).

## Install Xcode Command Line Tools

```bash
xcode-select --install
```

## Install Homebrew

Use the macOS default Terminal app.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval $(/opt/homebrew/bin/brew shellenv)
brew update
brew upgrade
```

Add the following line to both `~/.zshrc` and `~/.bash_profile`. Restart terminal.

```bash
eval $(/opt/homebrew/bin/brew shellenv)
```

## Use the latest version of `bash`

```bash
brew install bash bash-completion@2
```

Put `bash` inside `/usr/local/bin` (`/bin/bash` is too old).

```bash
pushd /usr/local/bin
sudo ln -s /opt/homebrew/bin/bash
popd
```

Change the default shell for both human admin user and `root`.

```bash
chsh -s /bin/bash
sudo chsh -s /bin/bash
```

Restart computer for the default shell change to take effect.

## Install and configure iTerm2

- [JetBrainsMono Nerd Font](https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip)

  Download. Unzip. Search for "Font Book" app. `File` --> `Add Fonts to Current User`.

- [Color scheme files for iTerm2](https://github.com/mbadolato/iTerm2-Color-Schemes/tree/master/schemes)

- [iTerm2](https://iterm2.com/)

  * Open iTerm2 Settings. Go to `Profiles` -> `Default`.
  * Under `General`, set `Command` to `Command`, `/usr/local/bin/bash -l -i`.
    Untick "Load shell integration automatically".
  * Under `Colors`, open the `Color Preset` dropdown and click `Import`. Import the color scheme file
    downloaded in the previous step. Then select the imported color scheme.
    Untick "Use separate colors for light and dark mode", "Use bright version of ANSI colors for bold text"
    and "Use custom color for bold text".
  * Under `Text`, set `Font` to `JetBrainsMono Nerd Font`, `Regular`, (size) `16`.
  * Under `Keys`, change `Left option key` to `Esc+`. This allows apps running in Tmux to receive the Alt key. 

From now on perform all CLI operations in iTerm2.

## Install essential utilities

```bash
brew install gawk rlwrap
```

## Install coding tools

When coding, run NeoVim inside Tmux sessions.

```bash
brew install git neovim ripgrep tmux pre-commit
```

## Install `pyenv`

`pyenv` is a CLI tool written in shell scripts. It installs multiple versions of Python by downloading and
compiling them from C source code. First we install various tools that are needed to compile Python interpreters.

```bash
brew install openssl readline sqlite3 xz zlib tcl-tk
```

Now install `pyenv` via `git clone` into the `~/.pyenv` folder.

```bash
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pushd ~/.pyenv && src/configure && make -C src && popd
```

## Install `pipx` and `poetry`

```bash
brew install pipx
pipx ensurepath
pipx install poetry
pipx inject poetry poetry-plugin-export
```

## Install `go`

```bash
brew install go
```

## Install `fnm`

`fnm` is a Node versions manager that doesn't cause a noticeable slow down at activation.
The CLI interface is largely similar to that of `nvm`.

```bash
brew install fnm
```

## Install AWS CLI v2

After installation, pin it to avoid unnecessary frequent version upgrade. It's enough to upgrade for every minor
version bump only.

```bash
brew install awscli
brew pin awscli
```

## Install GitHub CLI

For authentication against GitHub, the most convenient option is to use the GitHub CLI. To install, run the
following commands.

```bash
brew install gh
```

## Install `shellcheck`

```bash
brew install shellcheck
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

## Install Java, Maven and Gradle

First install [Amazon Corretto 11](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html) or another LTS version.
This manual installation is to avoid the Oracle OpenJDK that comes from `brew install openjdk`.

Open the file `~/.env.bashrc` and uncomment the line containing the following content and set the installed Java version.

```bash
#export JAVA_HOME=$(/usr/libexec/java_home -v SET_HERE)
```

Source `~/.bashrc` to refresh settings.

```bash
source ~/.bashrc
```

Manually install Maven and Gradle. Set their desired version numbers first.
Packages are installed in `~/.local/lib`. Symlinks to the binaries are created in `~/.local/bin`.

```bash
export MVN_VERSION=3.9.10
export GRADLE_VERSION=8.14.2

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
export GROOVY_VERSION=4.0.27

unzip -d ~/.local/lib ~/Downloads/apache-groovy-sdk-${GROOVY_VERSION}.zip
pushd ~/.local/bin && \
ls ~/.local/lib/groovy-${GROOVY_VERSION}/bin | grep -v '\.bat$' | grep -v '\.ico$' | xargs -I % sh -c "ln -s $HOME/.local/lib/groovy-${GROOVY_VERSION}/bin/%" && \
popd

rm ~/Downloads/apache-groovy-sdk-${GROOVY_VERSION}.zip
```

Open `~/.env.bashrc`, uncomment the line containing the following content and set the installed Groovy version.

```bash
#export GROOVY_HOME=$HOME/.local/lib/groovy-SET_HERE
```
