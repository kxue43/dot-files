# ------------------------------------------------------------------------
# Clean up symlinks in the $HOME/.local/state/fnm_multishells folder
if [ -d "${HOME}/.local/share/fnm" ]; then
  # We are assuming that fnm is on PATH as this script runs in .zlogout.
  eval "$(fnm env)"

  # Disable exit on error for cleanup.
  set +e

  # Remove the folder just created by the eval "$(fnm env)" above.
  unlink "${FNM_MULTISHELL_PATH}"

  # Remove fnm symlinks older than 7 days.
  echo "Cleaning up the $HOME/.local/state/fnm_multishells directory."
  find "$(dirname ${FNM_MULTISHELL_PATH})/" -type l -name '*_*' -mtime +7 -exec rm {} +
fi
# ------------------------------------------------------------------------
