#!/usr/local/bin/bash

set -e

make-zip() {
  git push

  declare -a zfiles=(.gvimrc .vimrc .bash_logout .bash_profile .bashrc)

  if [[ "$1" == "--initial" ]]; then
    zfiles+=(.vim/autoload/plug.vim .git-prompt.sh .gitconfig .gitconfig-personal .aws/config .aws/credentials)

    zip -r dot-files-initial.zip ${zfiles[@]}
  else
    zip -r dot-files-nightly.zip ${zfiles[@]}
  fi
}

publish-release() {
  make-zip
  make-zip --initial

  gh release create --latest ${1} dot-files-nightly.zip dot-files-initial.zip

  git pull

  rm dot-files-nightly.zip dot-files-initial.zip
}

delete-release() {
  gh release delete --cleanup-tag ${1}
}

PS3="Option: "

select name in publish-release delete-release "exit";
  do
    case $name in
      publish-release)
        chosen=$(echo -n $name | tr "-" " ")
        echo "Chose to ${chosen}."

        echo -n "New tag for release: "

        read tag

        publish-release $tag

        break
        ;;
      delete-release)
        chosen=$(echo -n $name | tr "-" " ")
        echo "Chose to ${chosen}."

        echo -n "Release tag to delete: "

        read tag

        delete-release $tag

        break
        ;;
      exit)
        echo "Exited without doing anything."

        break
        ;;
      *)
        cat << EOF
Please choose:
1) publish-release
2) delete-release
3) exit
EOF
        ;;
    esac
done
