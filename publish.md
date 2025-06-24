## Create `dot-files.zip`

Run the following command from the project root directory.

```bash
zip -r dot-files.zip \
.aws/config \
.aws/credentials \
.vim/autoload/plug.vim \
.git-prompt.sh \
.gvimrc \
.vimrc \
.zshrc
```

## Make a new release

After creating `dot-files.zip` in the project root folder, choose a right version tag and run the following
command. Follow prompts.

```bash
gh release create <TAG> --latest dot-files.zip
```
