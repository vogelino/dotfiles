# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# OS

if [ "$(uname -s)" = "Darwin" ]; then
  OS="MacOS"
else
  OS=$(uname -s)
fi

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)

READLINK=$(which greadlink || which readlink)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x "$READLINK" ]]; then
  SCRIPT_PATH=$($READLINK -f "$CURRENT_SCRIPT")
  DOTFILES_DIR=$(dirname "$(dirname "$SCRIPT_PATH")")
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return # `exit 1` would quit the shell itself
fi

# Finally we can source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{path,env,fzf,function,function_*,alias,alias.custom,powerlevel10k,nvm,yvm,custom,keybindings}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if [ "$OS" = "MacOS" ]; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Load zsh plugins
source "$DOTFILES_DIR/zsh/.plugins"

# Load bash completion (Added by vogelino as recommended by homebrew)
[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"

# Clean up
unset READLINK CURRENT_SCRIPT SCRIPT_PATH DOTFILE

# Export
export EDITOR='nvim'
export TERM="xterm-256color"
export OS DOTFILES_DIR 

# OH-MY-ZSH init
source $ZSH/oh-my-zsh.sh

test -e /Users/lucasvogel/.iterm2_shell_integration.zsh && source /Users/lucasvogel/.iterm2_shell_integration.zsh || true

