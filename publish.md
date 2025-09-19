## Make a new release

First commit all changes and push to remote.

```bash
git push
```

Then create new `dot-files-brew.zip` and `dot-files-macports.zip` by running the following command from project root.

```bash
make-zip() {
  cp .zprofile.${@} .zprofile && \
  zip -r dot-files-${@}.zip \
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
make-zip brew && make-zip macports
```

Choose a right version tag and run the following command. Follow prompts.

```bash
gh release create <TAG> --latest dot-files-brew.zip dot-files-macports.zip
```

Clean up release artifact.

```bash
rm dot-files-brew.zip dot-files-macports.zip
```

Finally pull the new tag from remote down to local.

```bash
git pull
```
