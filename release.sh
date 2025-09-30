#!/usr/bin/env bash

set -e

_download_assets() {
  mkdir -p ~+/.vim/autoload

  if [ -f ~+/.vim/autoload/plug.vim ]; then
    rm ~+/.vim/autoload/plug.vim
  fi

  if [ -f ~+/.git-prompt.sh ]; then
    rm ~+/.git-prompt.sh
  fi

  curl -o ~+/.vim/autoload/plug.vim -L https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  curl -o ~+/.git-prompt.sh -L https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
}

_make_zip() {
  git push

  _download_assets

  local -a zfiles=(.vim/autoload/plug.vim .git-prompt.sh .gvimrc .vimrc .bash_logout .bash_profile .bashrc .fns.bashrc)

  if [[ "$1" == "--initial" ]]; then
    zfiles+=(.gitconfig .gitconfig-personal .aws/config .aws/credentials)

    zip -r dot-files-initial.zip "${zfiles[@]}"
  else
    zip -r dot-files-nightly.zip "${zfiles[@]}"
  fi
}

_publish() {
  _make_zip
  _make_zip --initial

  gh release create -p=false --notes="${1}" --latest "${1}" dot-files-nightly.zip dot-files-initial.zip

  git pull

  rm dot-files-nightly.zip dot-files-initial.zip
}

_delete() {
  gh release delete --cleanup-tag -y "${1}"
}

main() {
  local name

  select name in increment publish delete; do
    echo "Chose to ${name} release."

    break
  done

  local tag

  case $name in
  publish)
    echo -n "New tag for release: "

    read -r tag

    _publish "$tag"
    ;;
  delete)
    echo -n "Release tag to delete: "

    read -r tag

    _delete "$tag"
    ;;
  increment)
    tag=$(git tag --sort=-version:refname | head -1)

    local version=${tag/#v/}
    local major=${version/%.?*/}
    local minor=${version/#?*./}
    minor=$((minor + 1))

    _publish "v${major}.${minor}"

    _delete "$tag"

    git pull

    echo "Published release v${major}.${minor}. Deleted ${tag}."
    ;;
  *)
    echo "Did not receive a valid option."
    ;;
  esac
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main
fi
