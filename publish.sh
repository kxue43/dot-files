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
  .bash_logout \
  .bash_profile \
  .bashrc
}

make-release() {
  gh release create --latest ${1} dot-files.zip
  git pull
  rm dot-files.zip
}

delete-release() {
  gh release delete --cleanup-tag ${1}
}

make-zip && make-release ${1}
