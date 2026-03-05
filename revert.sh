#!/bin/sh

backup_dir="$HOME/.backup_profiles"

if [ -d "$backup_dir" ]; then
  # Find the most recent backup
  latest=$(ls -1t "$backup_dir" | head -n1)
  if [ -n "$latest" ]; then
    for file in "$backup_dir/$latest"/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
      [ -r "$file" ] && cp "$file" "$HOME"
    done
    unset file
    echo "Successfully restored profile from $backup_dir/$latest"
    exec zsh -l
  else
    echo "No backups found in $backup_dir"
  fi
else
  echo "Could not find backup directory $backup_dir"
fi
