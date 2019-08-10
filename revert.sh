#!/bin/sh

if [ -d $HOME/.old_profile ]; then
  for file in $HOME/.old_profile/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
    [ -r "$file" ] && cp $file $HOME
  done
  unset file
  echo "Successfully restored profile from $HOME/.old_profile"
  exec zsh -l
else
  echo "Could not find directory $HOME/.old_profile"
fi