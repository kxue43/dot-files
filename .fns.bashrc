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
  _kxue43_prompt us-east-1 us-west-2
}
# ------------------------------------------------------------------------
_kxue43_prompt_jdk_version() {
  local -a versions=(
    $(/usr/libexec/java_home -V 2>&1 | grep -Eo "^\s*\d+\.\d+\.\d+")
  )

  _kxue43_prompt ${versions[@]}
}
# ------------------------------------------------------------------------
