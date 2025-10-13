# Set up a Debian 13 as Developer Machine

This document covers how to set up an `x86_64` Debian 13 as a developer machine. It provides installation steps,
and a few baseline dot files as a GitHub release asset. It is geared towards Go, Java, Python and JavaScript development.

All commands in this README should be executed from the user's home directory.

Don't use Wayland. VSCode doesn't work well with it. Use Xorg.

## Install Nvidia drivers.

Follow the steps on [Debian wiki](https://wiki.debian.org/NvidiaGraphicsDrivers).

Reboot.

## Install Flatpak and Flathub Firefox

```bash
sudo apt install flatpak gnome-software-plugin-flatpak
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

## Install VSCode

Download the `.deb` file from official VSCode website. Use `sudo apt install` on the downloaded file.

## Install basic CLI utilities

```bash
sudo apt install vim git curl
```

## Install `pyenv`

```bash
sudo apt install make build-essential libssl-dev zlib1g-dev \
libbz2-dev libreadline-dev libsqlite3-dev curl git \
libncursesw5-dev xz-utils tk-dev libxml2-dev libxmlsec1-dev libffi-dev liblzma-dev
```

## Install `pipx` and `poetry`

```bash
sudo apt install pipx
pipx ensure path
pipx install poetry
pipx inject poetry poetry-plugin-export
```

## Install `go`

```bash
sudo apt install golang
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

## Get baseline dot files

```bash
curl -o dot-files.zip -L https://github.com/kxue43/dot-files/releases/latest/download/dot-files-initial.zip
unzip -o dot-files.zip
rm dot-files.zip
rm ~/.profile
```

## Set Git global `user.name` and `user.email`

```bash
git config --global user.name YOUR_USER_NAME
git config --global user.email YOUR_EMAIL
```

## Install Go executables

Logout and login again so that new dot files take effect.

```bash
go install github.com/kxue43/cli-toolkit/cmd/toolkit@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-assume-role@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-serve-static@latest
go install github.com/kxue43/cli-toolkit/cmd/toolkit-show-md@latest
go install mvdan.cc/sh/v3/cmd/shfmt@latest
```

## Install Amazon Corretto Java

```bash
wget -O - https://apt.corretto.aws/corretto.key | sudo gpg --dearmor -o /usr/share/keyrings/corretto-keyring.gpg && \
echo "deb [signed-by=/usr/share/keyrings/corretto-keyring.gpg] https://apt.corretto.aws stable main" | sudo tee /etc/apt/sources.list.d/corretto.list
sudo apt modernize-sources
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
