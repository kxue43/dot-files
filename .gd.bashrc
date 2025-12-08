# ------------------------------------------------------------------------
# Secret environment variables.

# Source credentials from untracked file if exists.
[ -r "$HOME/.creds.bashrc" ] && source "$HOME/.creds.bashrc"

# GoDaddy NPM mirror – obtained from running `npm login --registry=https://gdartifactory1.jfrog.io/artifactory/api/npm/node-virt` and going through web auth.
export ARTIFACTORY_KEY

# GoDaddy Artifactory token for Docker virtual repo. From Artifactory web UI "Set me up".
export GD_JFROG_TOKEN
# ------------------------------------------------------------------------
# Environment variables.

# GoDaddy AWS profiles and regions.
export KXUE43_AWS_PROFILE_PREFIX="afternic"
export KXUE43_AWS_REGIONS="us-west-2:us-east-1"

# Go settings
export GOPRIVATE="github.secureserver.net/*,github.com/gdcorp-*"

# Java settings
JAVA_HOME=$(/usr/libexec/java_home -v 11)
export JAVA_HOME

# Groovy settings
export GROOVY_HOME=$HOME/.local/lib/groovy-5.0.2
# ------------------------------------------------------------------------
# Aliases.

alias gs='git status'
alias gce='gh copilot explain'
alias gwv='gh workflow view'
# ------------------------------------------------------------------------
# Functions.

enable-pyenv() {
  PATH="$HOME/.pyenv/bin:$PATH"

  eval "$(pyenv init -)"
}

tunnel-to-vm() {
  ssh "kxue1@kxue1#dc1.corp.gd@${1}@psmp.dc1.ca.iam.int.gd3p.tools"
}

sso-login() {
  aws sso login --sso-session sso-afternic
}

ssg-assume() {
  local accountId

  if ! accountId=$(
    set -o pipefail
    aws sts get-caller-identity --output json | jq -r ".Arn" | sed -E -e 's/^arn:aws:sts:://' -e 's/:assumed-role.+$//'
  ); then
    printf "\033[31m%s\033[0m\n" "Make sure you use a profile that can assume into the SSG deploy role first."

    return 1
  fi

  local -a values
  mapfile -t values < <(
    aws sts assume-role \
      --role-arn "arn:aws:iam::${accountId}:role/GD-AWS-SSG-Deploy-Role" \
      --role-session-name CLISession \
      --query "Credentials.[AccessKeyId,SecretAccessKey,SessionToken]" \
      --output json | jq -r '.[]'
  )

  export AWS_ACCESS_KEY_ID="${values[0]}"
  export AWS_SECRET_ACCESS_KEY="${values[1]}"
  export AWS_SESSION_TOKEN="${values[2]}"

  unset AWS_PROFILE
}

gd-ecr-docker-login() {
  aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 764525110978.dkr.ecr.us-west-2.amazonaws.com
}

gd-jfrog-docker-login() {
  docker login --username kxue1@godaddy.com --password "$GD_JFROG_TOKEN" gdartifactory1.jfrog.io
}

jsonify-log-file() {
  cat <<EOF
[$(cat "$1" | tr "\n" "," | sed 's/,$//')]
EOF
}

slack-test() {
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Kent test."}' "$1"
}
# ------------------------------------------------------------------------
