# Set up a MacBook as Developer Machine

## Introduction

This document covers how to set up a MacBook as a developer machine. It provides installation steps in this README,
and a few baseline dot files as a GitHub release asset. It is geared towards Go, Python and JavaScript development.

All commands in this README should be executed from the user's home directory.

## Install Xcode Command Line Tools

```bash
xcode-select --install
```

## Install `homebrew` and perform initial `update` and `upgrade`

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval $(/opt/homebrew/bin/brew shellenv)
brew update
brew upgrade
```

## Install `git`

```bash
brew install git
```

## Install `pyenv`

`pyenv` is a CLI tool written in shell scripts. It installs multiple versions of Python by downloading and
compiling them from C source code. A C compiler has been installed with Xcode Command Line Tools,
and here we install various C libraries that are needed to compile Python interpreters. 

```bash
brew install openssl readline sqlite3 xz zlib tcl-tk
```

Now install `pyenv` via `git clone` into the `~/.pyenv` folder.

```bash
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pushd ~/.pyenv && src/configure && make -C src && popd
```

## Install `pipx`

```bash
brew install pipx
```

## Install `go`

```bash
brew install go
```

## Install `fnm`

`fnm` is a Node versions manager that doesn't cause a noticeable slow down when sourcing `~/.zshrc`.
The CLI interface is largely similar to that of `nvm`.

```bash
brew install fnm
```

## Install `zsh-autosuggestions`

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```

## Set Git global user.name and user.email

```bash
git config --global user.name YOUR_USER_NAME
git config --global user.name YOUR_EMAIL
```

## Install GitHub CLI

For authentication against GitHub, the most convenient option is to use the GitHub CLI. To install, run the
following commands.

```bash
brew install gh
```

## Get baseline dot files

Get baseline dot files from GitHub. Note that they _overwrite_ existing local ones.

```bash
curl -o dot-files.zip -L https://github.com/kxue43/mac-dot-files/releases/latest/download/dot-files.zip
unzip -o dot-files.zip
rm dot-files.zip
```
