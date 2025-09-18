# Set up a MacBook as Developer Machine

## Introduction

This document covers how to set up a MacBook as a developer machine. It provides installation steps in this README,
and a few baseline dot files as a GitHub release asset. It is geared towards Go, Java, Python and JavaScript development.

All commands in this README should be executed from the user's home directory.

## Install Xcode Command Line Tools

```bash
xcode-select --install
```

## Install MacPorts

Use the GUI installer downloaded from the MacPorts website. Choose to use the "default prefix" during installation.

Set `PATH` for MacPorts in `~/.zshrc`. Restart terminal.

```bash
export PATH="/opt/local/bin:/opt/local/sbin:$PATH"
```

Perform initial `selfupdate`.

```bash
sudo port selfupdate
```

## Install `git`

```bash
sudo port install git
```

## Install `pyenv`

`pyenv` is a CLI tool written in shell scripts. It installs multiple versions of Python by downloading and
compiling them from C source code. A C compiler has been installed with Xcode Command Line Tools,
and here we install various C libraries that are needed to compile Python interpreters. 

```bash
sudo port install pkgconfig openssl xz gdbm tcl tk +quartz sqlite3 sqlite3-tcl zstd
```

Now install `pyenv` via `git clone` into the `~/.pyenv` folder.

```bash
git clone https://github.com/pyenv/pyenv.git ~/.pyenv
pushd ~/.pyenv && src/configure && make -C src && popd
```

## Install `pipx` and `poetry`

```bash
sudo port install pipx
pipx ensurepath
pipx install poetry
pipx inject poetry poetry-plugin-export
```

## Install `go`

```bash
sudo port install go
```

## Install `fnm`

`fnm` is a Node versions manager that doesn't cause a noticeable slow down when sourcing `~/.zshrc`.
The CLI interface is largely similar to that of `nvm`.

```bash
sudo port install fnm
```

## Install `zsh-autosuggestions`

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
```

## Install GitHub CLI

For authentication against GitHub, the most convenient option is to use the GitHub CLI. To install, run the
following commands.

```bash
sudo port install gh
```

## Get baseline dot files

Get baseline dot files from GitHub. Note that they _overwrite_ existing local ones.

```bash
rm ~/.zprofile
curl -o dot-files.zip -L https://github.com/kxue43/mac-dot-files/releases/latest/download/dot-files-macports.zip
unzip -o dot-files.zip
rm dot-files.zip
```

## Set Git global user.name and user.email

```bash
git config --global user.name YOUR_USER_NAME
git config --global user.email YOUR_EMAIL
```

## Install Java, Maven and Gradle

Don't install the Oracle OpenJDK.

First google "Amazon Corretto" and install an LTS version (8, 11, 17 or 21).

Open `~/.zshrc`, uncomment the line containing the following content and set the installed Java version.

```bash
#export JAVA_HOME=$(/usr/libexec/java_home -v <SET-HERE>)
```

Source `~/.zshrc` to refresh settings.

```bash
source ~/.zshrc
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

Download a Groovy distribution into the `~/Downloads` folder, e.g. use [this link](https://groovy.apache.org/download.html).
Set the `GROOVY_VERSION` environment variable below to the corresponding version.

```bash
export GROOVY_VERSION=4.0.27

unzip -d ~/.local/lib ~/Downloads/apache-groovy-sdk-${GROOVY_VERSION}.zip
pushd ~/.local/bin && \
ls ~/.local/lib/groovy-${GROOVY_VERSION}/bin | grep -v '\.bat$' | grep -v '\.ico$' | xargs -I % sh -c "ln -s $HOME/.local/lib/groovy-${GROOVY_VERSION}/bin/%" && \
popd

rm ~/Downloads/apache-groovy-sdk-${GROOVY_VERSION}.zip
```

Open `~/.zshrc`, uncomment the line containing the following content and set the installed Groovy version.

```bash
#export GROOVY_HOME=$HOME/.local/lib/groovy-<SET-HERE>
```

## Install toolkit executables

```bash
go install github.com/kxue43/cli-toolkit/cmd/toolkit@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-assume-role@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-serve-static@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-show-md@latest
```

## GUIs and their links

- [Amazon Corretto 11](https://docs.aws.amazon.com/corretto/latest/corretto-11-ug/downloads-list.html)

- [MacVim](https://macvim.org/)

- [DejaVu Sans Mono font](https://www.fontsquirrel.com/fonts/dejavu-sans-mono)

  Download. Unzip. Search for "Font Book" app. `File` --> `Add Fonts to Current User`.
