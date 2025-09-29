# ------------------------------------------------------------------------
# Functions.
# ------------------------------------------------------------------------
_kxue43_prompt() {
  local chosen=

  select chosen in "$@"
    do
      echo "Chose $chosen." >&2

      break
  done

  echo $chosen
}
# ------------------------------------------------------------------------
_kxue43_prompt_aws_profile() {
  local -a profiles=(
    $(cat ~/.aws/config | grep "^\[profile $1" | sed -E -e "s/^\[profile //g" -e "s/]$//g")
  )

  _kxue43_prompt "${profiles[@]}"
}
# ------------------------------------------------------------------------
_kxue43_prompt_aws_region() {
  local -a regions

  if [ -z "${1:+x}" ]; then
    regions=(us-east-1 us-west-2)
  else
    regions=( ${1//:/ } )
  fi

  _kxue43_prompt "${regions[@]}"
}
# ------------------------------------------------------------------------
_kxue43_prompt_jdk_version() {
  local -a versions=(
    $(/usr/libexec/java_home -V 2>&1 | grep -Eo "^\s*\d+\.\d+\.\d+")
  )

  _kxue43_prompt "${versions[@]}"
}
# ------------------------------------------------------------------------
