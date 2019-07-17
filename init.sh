if [ ! -d $HOME/.old_profile ]; then
  mkdir $HOME/.old_profile
fi
echo 'Moving old scripts into ' $HOME/.old_profile
for file in $HOME/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path}; do
  cp $file $HOME/.old_profile
done
unset file
for file in ./src/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path}; do
  echo 'Copying ' $file ' into ' $HOME
  cp $file $HOME
done
unset file
echo ${BOLD} 'Done'