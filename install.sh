#!/bin/sh

project_root="$( cd "$(dirname "$0")" >/dev/null 2>&1 || exit ; pwd -P )"

# Install Homebrew if missing
if ! command -v brew >/dev/null 2>&1; then
  printf "Installing Homebrew...\n"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # shellcheck disable=SC2312
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv 2>/dev/null)"
fi

if [ ! -d "$HOME/.backup_profiles" ]; then
  mkdir "$HOME/.backup_profiles"
fi
currentDate=$(date +%Y-%m-%d--%H-%M-%S)

mkdir "$HOME/.backup_profiles/$currentDate"

printf '\n'
printf 'Moving old profile into %s %s %s\n' "${YELLOW}" "$HOME/.backup_profiles/$currentDate" "${RESET}"
printf '\n'

for file in "$HOME"/.{aliases,bash_profile,bash_prompt,exports,extra,functions,secrets,path,zshenv,zshrc}; do
  [ -r "$file" ] && cp "$file" "$HOME/.backup_profiles/$currentDate"
done
unset file

# Backup existing husky init.sh if present
husky_init="${XDG_CONFIG_HOME:-$HOME/.config}/husky/init.sh"
if [ -r "$husky_init" ]; then
  mkdir -p "$HOME/.backup_profiles/$currentDate/.config/husky"
  cp "$husky_init" "$HOME/.backup_profiles/$currentDate/.config/husky/init.sh"
fi

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

# Install Docker if not present
if ! command -v docker >/dev/null 2>&1; then
  brew install --cask docker
fi

# Install Crush CLI if not present
if ! command -v crush >/dev/null 2>&1; then
  brew install charmbracelet/tap/crush
fi

# Install default Node LTS via nvm if no default is set
export NVM_DIR="$HOME/.nvm"
# shellcheck disable=SC1091
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
if ! nvm ls default >/dev/null 2>&1; then
  printf "Installing Node LTS via nvm...\n"
  nvm install --lts
  nvm alias default 'lts/*'
fi

# Enable yarn via corepack (ships with Node 16+)
if ! command -v yarn >/dev/null 2>&1; then
  corepack enable
fi

# Install Netlify CLI globally if not present
if ! command -v netlify >/dev/null 2>&1; then
  npm install -g netlify-cli
fi

for file in "$project_root"/lib/.{aliases,bash_profile,bash_prompt,exports,extra,functions,path,zshenv,zshrc}; do
  [ -r "$file" ] && cp "$file" "$HOME"
done
unset file

# Install husky init.sh for nvm PATH in git hooks (husky v9+)
husky_init_src="$project_root/lib/.config/husky/init.sh"
husky_init_dir="${XDG_CONFIG_HOME:-$HOME/.config}/husky"
if [ -r "$husky_init_src" ]; then
  mkdir -p "$husky_init_dir"
  cp "$husky_init_src" "$husky_init_dir/init.sh"
fi

# Merge secrets: copy lib/.secrets to ~/.secrets, preserving existing values
secrets_src="$project_root/lib/.secrets"
secrets_file="$HOME/.secrets"
if [ -r "$secrets_src" ]; then
  if [ ! -f "$secrets_file" ]; then
    cp "$secrets_src" "$secrets_file"
    printf 'Created %s\n' "$secrets_file"
  else
    # Append export lines whose variable name is not already in ~/.secrets
    while IFS= read -r line; do
      var_name=$(printf '%s' "$line" | sed -n 's/^export \([A-Z_]*\)=.*/\1/p')
      [ -z "$var_name" ] && continue
      if ! grep -q "$var_name" "$secrets_file"; then
        printf '%s\n' "$line" >> "$secrets_file"
        printf 'Added %s to %s\n' "$var_name" "$secrets_file"
      fi
    done < "$secrets_src"
  fi
fi
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
