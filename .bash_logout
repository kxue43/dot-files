# ------------------------------------------------------------------------
# Clean up symlinks in the $HOME/.local/state/fnm_multishells folder on macOS.
# On Debian the symlinks live under /run/user/uid/... and are already temporary.
if [ "$(uname -s)" = "Darwin" ] && [ -d "${HOME}/.local/share/fnm" ]; then
  # Disable exit on error for cleanup.
  set +e

  # We are assuming that fnm is on PATH as this script runs in .bash_logout.
  eval "$(fnm env)"

  if [ -n "${FNM_MULTISHELL_PATH:+x}" ]; then
    # Remove fnm symlinks older than 365 days. This is because tmux
    # might have long-living sessions, so we cannot delete directories
    # used by them.
    echo "Cleaning up the $HOME/.local/state/fnm_multishells directory."

    find "$(dirname "${FNM_MULTISHELL_PATH}")/" -type l -name '*_*' -mtime +365d -exec rm {} +
  fi
fi
# ------------------------------------------------------------------------
