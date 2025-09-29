# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
_kxue43_prompt() {
  local chosen

  select chosen in "$@"; do
    echo "Chose $chosen." >&2

    break
  done

  echo "$chosen"
}
# ------------------------------------------------------------------------
_kxue43_prompt_aws_profile() {
  local -a profiles

  mapfile -t profiles < <(grep "^\[profile $1" ~/.aws/config)

  profiles=("${profiles[@]/#\[profile /}")

  profiles=("${profiles[@]/%\]/}")

  _kxue43_prompt "${profiles[@]}"
}
# ------------------------------------------------------------------------
_kxue43_prompt_aws_region() {
  local -a regions

  if [ -z "${1:+x}" ]; then
    regions=(us-east-1 us-west-2)
  else
    mapfile -t -d : regions <<<"$1"
  fi

  _kxue43_prompt "${regions[@]}"
}
# ------------------------------------------------------------------------
_kxue43_prompt_jdk_version() {
  local -a versions

  mapfile -t versions < <(/usr/libexec/java_home -V 2>&1 | grep -Eo "^\s*\d+\.\d+\.\d+" | awk '{print $1}')

  _kxue43_prompt "${versions[@]}"
}
# ------------------------------------------------------------------------
