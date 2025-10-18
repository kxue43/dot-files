# This script should only be executed in GitHub Actions.
# It's intentionally not given the +x permission.

set -e

_download_assets() {
  curl -o ~+/.git-prompt.sh -Lf https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
}

_make_zip() {
  local -a zfiles=(.git-prompt.sh .bash_logout .bash_profile .bashrc .fns.bashrc .tmux.conf)

  if [[ "$1" == "--initial" ]]; then
    zfiles+=(.gitconfig .gitconfig-personal .aws/config .aws/credentials)

    zip -r dot-files-initial.zip "${zfiles[@]}"
  else
    zip -r dot-files-nightly.zip "${zfiles[@]}"
  fi
}

_publish() {
  _download_assets

  _make_zip
  _make_zip --initial

  gh release create -p=false --notes="${1}" --latest "${1}" dot-files-nightly.zip dot-files-initial.zip
}

_delete() {
  gh release delete --cleanup-tag -y "${1}"
}

main() {
  if [ -z "${GITHUB_ACTIONS+x}" ]; then
    echo "release.sh should only be executed in GitHub Actions."
    exit 1
  fi

  tag=$(git tag --sort=-version:refname | head -1)

  local version=${tag/#v/}
  local major=${version/%.?*/}
  local minor=${version/#?*./}
  minor=$((minor + 1))

  _publish "v${major}.${minor}"

  _delete "$tag"

  echo "Published release v${major}.${minor}. Deleted ${tag}."
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  # Since there is "set -e", use subshell to prevent failure from causing current shell to exit.
  (main)
fi
