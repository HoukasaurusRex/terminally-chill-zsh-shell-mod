#!/bin/sh

if [ ! -d $HOME/.backup_profiles ]; then
  mkdir $HOME/.backup_profiles
fi
currentDate=`date +%Y-%m-%d--%H-%M-%S`

mkdir $HOME/.backup_profiles/$currentDate

echo '\n'
echo 'Moving old scripts into ' ${YELLOW} $HOME/.backup_profiles/$currentDate ${RESET}
echo '\n'

for file in $HOME/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  [ -r "$file" ] && cp $file $HOME/.backup_profiles/$currentDate
done
unset file

if [ ! -d $HOME/.oh-my-zsh ]; then
  sh oh-my-zsh/tools/install.sh
else
  sh oh-my-zsh/tools/upgrade.sh
fi

for file in ./lib/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  [ -r "$file" ] && cp $file $HOME
done
unset file
printf "$MAGENTA"
	cat <<-'EOF'
  
  Your shell is now...                                                                                                                                                                                                                                    
  _______                     __             __ __       _______ __    __ __ __ 
 |       .-----.----.--------|__.-----.---.-|  |  .--.--|   _   |  |--|__|  |  |
 |.|   | |  -__|   _|        |  |     |  _  |  |  |  |  |.  1___|     |  |  |  |
 `-|.  |-|_____|__| |__|__|__|__|__|__|___._|__|__|___  |.  |___|__|__|__|__|__|
   |:  |                                          |_____|:  1   |               
   |::.|                                                |::.. . |               
   `---'                                                `-------'               
                                                                                                                                                                                                                                                   
  
EOF
printf "$RESET"

printf "If you're happy with this shell profile mod (or not), let me hear it on Twitter @HoukasaurusRex (https://twitter.com/HoukasaurusRex)\n\n"

echo 'Run ' ${YELLOW} '[help] ' ${RESET} 'for details on custom functions and aliases'

exec zsh -l
