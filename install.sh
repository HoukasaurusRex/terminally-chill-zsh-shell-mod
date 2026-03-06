#!/bin/sh

project_root="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"

if [ ! -d "$HOME/.backup_profiles" ]; then
  mkdir "$HOME/.backup_profiles"
fi
currentDate=$(date +%Y-%m-%d--%H-%M-%S)

mkdir "$HOME/.backup_profiles/$currentDate"

printf '\n'
printf 'Moving old profile into %s %s %s\n' "${YELLOW}" "$HOME/.backup_profiles/$currentDate" "${RESET}"
printf '\n'

for file in "$HOME"/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  [ -r "$file" ] && cp "$file" "$HOME/.backup_profiles/$currentDate"
done
unset file

# Initialize oh-my-zsh submodule if not populated
if [ ! -f "$project_root/oh-my-zsh/oh-my-zsh.sh" ]; then
  git -C "$project_root" submodule update --init
fi

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  sh "$project_root/oh-my-zsh/tools/install.sh"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# Install Powerlevel10k theme if not present
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
fi

# Install zsh-autosuggestions plugin if not present
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions.git "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# Install zsh-syntax-highlighting plugin if not present
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
  git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

for file in "$project_root"/lib/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshrc}; do
  [ -r "$file" ] && cp "$file" "$HOME"
done
unset file
printf '%s' "$MAGENTA"
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
printf '%s' "$RESET"

printf "If you're happy with this shell profile mod (or not), let me hear it on Twitter @HoukasaurusRex (https://twitter.com/HoukasaurusRex)\n\n"

printf 'Run %s [tch] %s for details on custom functions and aliases\n' "${YELLOW}" "${RESET}"

exec zsh -l
