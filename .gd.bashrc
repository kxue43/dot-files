# ------------------------------------------------------------------------
# Secret environment variables.
# ------------------------------------------------------------------------
# Source credentials from untracked file if exists.
# shellcheck disable=SC1091
[ -r "$HOME/.creds.bashrc" ] && source "$HOME/.creds.bashrc"

# GoDaddy NPM mirror – obtained from running `npm login --registry=https://gdartifactory1.jfrog.io/artifactory/api/npm/node-virt` and going through web auth.
export ARTIFACTORY_KEY

# GoDaddy Artifactory token for Docker virtual repo. From Artifactory web UI "Set me up".
export GD_JFROG_TOKEN
# ------------------------------------------------------------------------
# Environment variables.
# ------------------------------------------------------------------------
# GoDaddy AWS profiles and regions.
export KXUE43_AWS_PROFILE_PREFIX="afternicint-"
export KXUE43_AWS_REGIONS="us-west-2:us-east-1"

# Go settings
export GOPRIVATE="github.secureserver.net/*,github.com/gdcorp-*"

# Java settings
JAVA_HOME=$(/usr/libexec/java_home -v 11)
export JAVA_HOME

# Groovy settings
export GROOVY_HOME=$HOME/.local/lib/groovy-4.0.27
# ------------------------------------------------------------------------
# Aliases.
# ------------------------------------------------------------------------
alias gs='git status'
alias gce='gh copilot explain'
alias gwv='gh workflow view'
# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
tunnel-to-vm() {
  ssh "kxue1@kxue1#dc1.corp.gd@${1}@psmp.dc1.ca.iam.int.gd3p.tools"
}
# ------------------------------------------------------------------------
sso-login() {
  aws sso login --sso-session sso-afternicint
}
# ------------------------------------------------------------------------
# Assume SSG Deploy role
ssg-assume() {
  case ${1:-dp} in
  dp)
    accountId=765712374873
    ;;
  dev)
    accountId=768290660679
    ;;
  test)
    accountId=926654972661
    ;;
  ote)
    accountId=515832443534
    ;;
  prod)
    accountId=871377637535
    ;;
  *)
    _kxue43_color_echo red "Target env must be dp, dev, test, ote or prod."

    return 1
    ;;
  esac

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
# ------------------------------------------------------------------------
gd-ecr-docker-login() {
  aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin 764525110978.dkr.ecr.us-west-2.amazonaws.com
}
# ------------------------------------------------------------------------
gd-jfrog-docker-login() {
  docker login --username kxue1@godaddy.com --password "$GD_JFROG_TOKEN" gdartifactory1.jfrog.io
}
# ------------------------------------------------------------------------
jsonify-log-file() {
  cat <<EOF
[$(cat "$1" | tr "\n" "," | sed 's/,$//')]
EOF
}
# ------------------------------------------------------------------------
slack-test() {
  curl -X POST -H 'Content-type: application/json' --data '{"text":"Kent test."}' "$1"
}
# ------------------------------------------------------------------------
invoke-recon-lambda() {
  local date
  local env=dev-private

  local opt OPTIND OPTARG

  while getopts ":hd:e:" opt; do
    case "$opt" in
    h)
      cat <<EOF
USAGE: ${FUNCNAME[0]} -d DATE [-e ENV] [-h] [OUT_FILE]

Invoke the am-event-bus-producer-recon Lambda so that it collects
all Event IDs of the given DATE and send a PUBLISHED_EVENTS_LIST
event to Event Bus.

OPTIONS:
    -d            Date to collect Event IDs for.
    -e            Target AWS environment. Must be dev-private or ote.
                  Defaults to dev-private.
    -h            Show help message.

ARGUMENTS:
    OUT_FILE      Path to the file that holds invocation response.
                  If not given, echo response to stdout.
EOF

      return 0
      ;;
    d)
      date="$OPTARG"
      ;;
    e)
      env="$OPTARG"
      ;;
    \?)
      echo "Invalid option: -$OPTARG"

      return 1
      ;;
    :)
      echo "Option -$OPTARG requires argument."

      return 1
      ;;
    esac
  done

  shift $((OPTIND - 1))

  if [ -z "$date" ]; then
    echo "The -d DATE option is required."

    return 1
  fi

  if ! date=$(date -v +1d -j -f "%Y-%m-%d" "$date" "+%Y-%m-%d" 2>/dev/null); then
    echo "The DATE option value is not a valid date of the yyyy-mm-dd format."

    return 1
  fi

  if ! [ "$env" == "dev-private" ] && ! [ "$env" == "ote" ]; then
    echo "The ENV option value must be dev-private or ote."

    return 1
  fi

  local payload
  payload=$(
    base64 <<EOF
{
  "id": "cdc73f9d-aea9-11e3-9d5a-835b769c0d9c",
  "detail-type": "Scheduled Event",
  "source": "aws.events",
  "account": "123456789012",
  "time": "${date}T07:32:00Z",
  "region": "us-east-1",
  "resources": ["arn:aws:events:us-east-1:123456789012:rule/MyScheduledRule"],
  "detail": {}
}
EOF
  )

  local outfile

  if (($# > 0)); then
    outfile="$1"
  else
    outfile=$(mktemp)

    trap 'rm -f "$outfile"' RETURN
  fi

  aws lambda invoke --function-name am-event-bus-producer-recon --payload "$payload" "$outfile"

  cat "$outfile"
}
# ------------------------------------------------------------------------
