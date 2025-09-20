#!/bin/bash

make-zip() {
  git push && \
  zip -r dot-files.zip \
  .aws/config \
  .aws/credentials \
  .vim/autoload/plug.vim \
  .git-prompt.sh \
  .gitconfig \
  .gitconfig-personal \
  .gvimrc \
  .vimrc \
  .zprofile \
  .zshrc
}

make-release() {
  gh release create --latest -p=false -n "" ${1} dot-files.zip
  git pull
}

make-zip && make-release ${1}
