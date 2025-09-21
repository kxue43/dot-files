# ------------------------------------------------------------------------
# Clean up symlinks in the $HOME/.local/state/fnm_multishells folder
FNM_PATH="${HOME}/.local/share/fnm"
if [ -d "${FNM_PATH}" ]; then
  eval "$(fnm env)"

  # Disable exit on error for cleanup.
  set +e

  # Remove the folder just created by the eval "$(fnm env)" above.
  rm -f "${FNM_MULTISHELL_PATH}"

  # Remove fnm symlinks older than 7 days.
  find "$(dirname ${FNM_MULTISHELL_PATH})/" -type l -name '*_*' -mtime +7 -delete &>/dev/null
fi
# ------------------------------------------------------------------------
