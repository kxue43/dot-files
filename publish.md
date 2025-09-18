## Make a new release

First commit all changes and push to remote.

```bash
git push
```

Then create new `dot-files-brew.zip` and `dot-files-macports.zip` by running the following command from project root.

```bash
cp .zshrc.brew .zshrc && \
zip -r dot-files-brew.zip \
.aws/config \
.aws/credentials \
.vim/autoload/plug.vim \
.git-prompt.sh \
.gitconfig \
.gitconfig-personal \
.gvimrc \
.vimrc \
.zshrc && \
rm .zshrc && cp .zshrc.macports .zshrc && \
zip -r dot-files-macports.zip \
.aws/config \
.aws/credentials \
.vim/autoload/plug.vim \
.git-prompt.sh \
.gitconfig \
.gitconfig-personal \
.gvimrc \
.vimrc \
.zshrc
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
