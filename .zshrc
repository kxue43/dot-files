# ------------------------------------------------------------------------
# Aliases.
alias gproj='cd ~/projects'
alias gtemp='cd ~/temp'
alias glg='git log --graph --oneline --all'
alias venvact='. .venv/bin/activate'
alias clean-aws-cache="unset AWS_SESSION_TOKEN && unset AWS_SECRET_ACCESS_KEY && unset AWS_ACCESS_KEY_ID && rm -rf ~/.aws/boto/cache"
alias gs='git status'
alias gci='aws sts get-caller-identity'
# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
function glo {
    git log --oneline $@
}
# ------------------------------------------------------------------------
function gsh {
    git show --name-only $@
}
# ------------------------------------------------------------------------
function my-diff {
    git diff --no-index $1 $2
}
# ------------------------------------------------------------------------
function code {
    VSCODE_CWD="$PWD" open -n -b "com.microsoft.VSCode" --args $*
}
# ------------------------------------------------------------------------
# Enhance terminal prompt with Git info. This has nothing to do with Git completion.
source ~/.git-prompt.sh
setopt PROMPT_SUBST ; PS1=$'%B%F{cyan}%n@localhost:%F{12}%~%F{11} $(__git_ps1 "(%s)")\n%(?.%F{10}\U2714.%F{9}\U2718)%b%f\$ '
# ------------------------------------------------------------------------
# Use installed zsh completions.
if type brew &>/dev/null; then
  FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH
  autoload -Uz compinit
  compinit
fi
# ------------------------------------------------------------------------
# Activate zsh-autosuggestions.
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
bindkey '^ ' autosuggest-accept
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# Ideally the following should be placed in ~/.zprofile, but their current
# implementations require being put here.
# ------------------------------------------------------------------------
# ------------------------------------------------------------------------
# Activate fnm - doesn't cause a slow down as nvm.
eval "$(fnm env --use-on-cd --shell zsh)"
# ------------------------------------------------------------------------
