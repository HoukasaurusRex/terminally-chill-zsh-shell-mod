#!/bin/sh

project_root="$( cd "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )" # https://stackoverflow.com/a/4774063/8210954

TSH_DIR="$HOME/.terminally-chill-shell"

if [ ! -d $TSH_DIR ]; then
  mkdir $TSH_DIR
fi
if [ ! -d $TSH_DIR/.backup_profiles ]; then
  mkdir $TSH_DIR/.backup_profiles
fi
currentDate=`date +%Y-%m-%d--%H-%M-%S`

mkdir $TSH_DIR/.backup_profiles/$currentDate

echo '\n'
echo 'Moving old scripts into ' ${YELLOW} $TSH_DIR/.backup_profiles/$currentDate ${RESET}
echo '\n'

for file in $TSH_DIR/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  [ -r "$file" ] && cp $file $TSH_DIR/.backup_profiles/$currentDate
done
unset file

if [ ! -d $HOME/.oh-my-zsh ]; then
  sh oh-my-zsh/tools/install.sh
fi

for file in $project_root/lib/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  [ -r "$file" ] && cp $file $TSH_DIR
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

echo 'Run ' ${YELLOW} '[tch] ' ${RESET} 'for details on custom functions and aliases'

exec zsh -l
