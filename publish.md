## Make a new release

First commit all changes and push to remote.

```bash
git push
```

Then create a new `dot-files.zip` by running the following command from project root.

```bash
zip -r dot-files.zip \
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
gh release create <TAG> --latest dot-files.zip
```

Finally pull the new tag from remote down to local.

```bash
git pull
```
