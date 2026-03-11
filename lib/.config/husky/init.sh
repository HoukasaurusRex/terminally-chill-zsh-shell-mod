#!/bin/sh

# Add nvm default node to PATH for husky git hooks (v9+).
# Husky runs hooks under /bin/sh (non-interactive, non-login) which reads
# no startup files — so nvm-managed binaries (node, yarn, npx) are missing
# from PATH. Husky sources this file before running hooks.
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
if [ -d "$NVM_DIR/versions/node" ]; then
  # shellcheck disable=SC2012
  _nvm_node_path=$(ls -d "$NVM_DIR/versions/node"/*/bin 2>/dev/null | sort -V | tail -1)
  if [ -d "$_nvm_node_path" ]; then
    export PATH="$_nvm_node_path:$PATH"
  fi
  unset _nvm_node_path
fi
