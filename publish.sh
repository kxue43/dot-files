#!/bin/bash

make-zip() {
  git push && \
  cp .zprofile.${1} .zprofile && \
  zip -r dot-files-${1}.zip \
  .aws/config \
  .aws/credentials \
  .vim/autoload/plug.vim \
  .git-prompt.sh \
  .gitconfig \
  .gitconfig-personal \
  .gvimrc \
  .vimrc \
  .zprofile \
  .zshrc && \
  rm .zprofile
}

make-release() {
  gh release create --latest -p=false -n "" ${1} dot-files-brew.zip dot-files-macports.zip
  git pull
  rm dot-files-brew.zip dot-files-macports.zip
}

make-zip brew && make-zip macports && make-release ${1}
