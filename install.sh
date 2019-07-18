if [ ! -d $HOME/.old_profile ]; then
  mkdir $HOME/.old_profile
fi

echo '\n'
echo 'Moving old scripts into ' ${YELLOW} $HOME/.old_profile ${RESET}
echo '\n'

for file in $HOME/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  cp $file $HOME/.old_profile
done
unset file

if [ ! -d $HOME/.oh-my-zsh ]; then
  sh oh-my-zsh/tools/install.sh
  echo 'install'
else
  sh oh-my-zsh/tools/upgrade.sh
  echo 'upgrade'
fi

for file in ./src/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  cp $file $HOME
done
unset file
printf "$MAGENTA"
	cat <<-'EOF'
  
  Your terminal is now...                                                                                                                                                                                                                                    
  _______                     __             __ __       _______ __    __ __ __ 
 |       .-----.----.--------|__.-----.---.-|  |  .--.--|   _   |  |--|__|  |  |
 |.|   | |  -__|   _|        |  |     |  _  |  |  |  |  |.  1___|     |  |  |  |
 `-|.  |-|_____|__| |__|__|__|__|__|__|___._|__|__|___  |.  |___|__|__|__|__|__|
   |:  |                                          |_____|:  1   |               
   |::.|                                                |::.. . |               
   `---'                                                `-------'               
                                                                                                                                                                                                                                                   
                                                                                                                                                                                                                                      
EOF
printf "$RESET"

echo 'Run ' ${YELLOW} '[help] ' ${RESET} 'for details on custom functions'

exec zsh -l
