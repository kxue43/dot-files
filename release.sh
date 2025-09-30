#!/usr/bin/env bash

set -e

_delete_assets() {
  if [ -d ~+/.vim ]; then
    rm -rf ~+/.vim
  fi

  if [ -f ~+/.git-prompt.sh ]; then
    rm ~+/.git-prompt.sh
  fi

  local basename

  for basename in dot-files-nightly.zip dot-files-initial.zip; do
    if [ -f ~+/$basename ]; then
      rm ~+/$basename
    fi
  done
}

_download_assets() {
  mkdir -p ~+/.vim/autoload

  curl -o ~+/.vim/autoload/plug.vim -Lf https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  curl -o ~+/.git-prompt.sh -Lf https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
}

_make_zip() {
  local -a zfiles=(.vim/autoload/plug.vim .git-prompt.sh .gvimrc .vimrc .bash_logout .bash_profile .bashrc .fns.bashrc)

  if [[ "$1" == "--initial" ]]; then
    zfiles+=(.gitconfig .gitconfig-personal .aws/config .aws/credentials)

    zip -r dot-files-initial.zip "${zfiles[@]}"
  else
    zip -r dot-files-nightly.zip "${zfiles[@]}"
  fi
}

_publish() {
  if [ -z "${GITHUB_ACTIONS+x}" ]; then
    git pull && git push
  fi

  _delete_assets

  _download_assets

  _make_zip
  _make_zip --initial

  gh release create -p=false --notes="${1}" --latest "${1}" dot-files-nightly.zip dot-files-initial.zip

  if [ -z "${GITHUB_ACTIONS+x}" ]; then
    git pull
  fi

  _delete_assets
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
  # Since there is "set -e", use subshell to prevent failure from causing current shell to exit.
  (main)
fi
