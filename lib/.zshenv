
# Add nvm default node to PATH for non-interactive shells (MCP servers, etc.)
export NVM_DIR="$HOME/.nvm"
if [ -d "$NVM_DIR/versions/node" ]; then
  _nvm_node_path=$(ls -d "$NVM_DIR/versions/node"/*/bin 2>/dev/null | sort -V | tail -1)
  [ -d "$_nvm_node_path" ] && export PATH="$_nvm_node_path:$PATH"
  unset _nvm_node_path
fi
