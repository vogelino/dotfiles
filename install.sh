#!/bin/bash

# -------------------------------------------------------
# HOMEBREW
# -------------------------------------------------------
# Check if Homebrew is installed. If so, update it. If not, install it.
if command -v brew >/dev/null 2>&1; then
    echo "Homebrew is already installed. Updating..."
    brew update
else
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Installing homebrew packages
brew bundle --file=$DOTFILES_DIR/install/Brewfile
brew bundle --file=$DOTFILES_DIR/install/Caskfile

# -------------------------------------------------------
# DOTFILES
# -------------------------------------------------------
backup_and_symlink_file() {
    local src="$1"
    local dst="$2"

    # Check if destination exists
    if [ -e "$dst" ]; then
        # Check if it's already a symlink pointing to the right location
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            echo "✓ $dst is already correctly linked to $src"
            return 0
        fi

        # It exists but isn't the correct symlink, so back it up
        echo "⚠️ Backing up existing $dst to ${dst}.bak"
        cp -r "$dst" "${dst}.bak"
    fi

    # Create the symlink
    echo "➡️ Linking $src to $dst"
    ln -sf "$src" "$dst"
}

backup_and_symlink_dir() {
    local src="$1"
    local dst="$2"

    # Check if destination exists
    if [ -e "$dst" ]; then
        # Check if it's already a symlink pointing to the right location
        if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
            echo "✓ $dst is already correctly linked to $src"
            return 0
        fi

        # It exists but isn't the correct symlink, so back it up
        echo "⚠️ Backing up existing $dst to ${dst}.bak"
        cp -r "$dst" "${dst}.bak"
    fi

    # Create the symlink
    echo "➡️ Linking $src to $dst"
    ln -sf "$src" "$dst"
}

# ZSH
backup_and_symlink_file "$DOTFILES_DIR/runcom/.zshrc" "$HOME/.zshrc"

# TMUX
backup_and_symlink_file "$DOTFILES_DIR/runcom/.tmux.conf" "$HOME/.tmux.conf"

# POWERLEVEL10K
backup_and_symlink_file "$DOTFILES_DIR/runcom/.p10k.zsh" "$HOME/.p10k.zsh"

# NPM
backup_and_symlink_file "$DOTFILES_DIR/runcom/.npmrc" "$HOME/.npmrc"

# -------------------------------------------------------
# .CONFIG
# -------------------------------------------------------
# Check if the .config directory exists. If not, create it.
mkdir -p "$HOME/.config"

# GHOSTTY
mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
backup_and_symlink_file "$DOTFILES_DIR/.config/ghostty/config" "$HOME/Library/Application Support/com.mitchellh.ghostty/config"

# GIT
backup_and_symlink_file "$DOTFILES_DIR/.config/git/.gitconfig.local" "$HOME/.gitconfig.local"
backup_and_symlink_file "$DOTFILES_DIR/.config/git/.gitconfig" "$HOME/.gitconfig"

# SSH
backup_and_symlink_file "$DOTFILES_DIR/.config/ssh/config.local" "$HOME/.ssh/config.local"
backup_and_symlink_file "$DOTFILES_DIR/.config/ssh/config" "$HOME/.ssh/config"

# GLOW
backup_and_symlink_dir "$DOTFILES_DIR/.config/glow" "$HOME/.config/glow"

# LAZYGIT
backup_and_symlink_dir "$DOTFILES_DIR/.config/lazygit" "$HOME/.config/lazygit"

# LF
backup_and_symlink_dir "$DOTFILES_DIR/.config/lf" "$HOME/.config/lf"

# NVIM
backup_and_symlink_dir "$DOTFILES_DIR/.config/nvim" "$HOME/.config/nvim"

# SESH
backup_and_symlink_dir "$DOTFILES_DIR/.config/sesh" "$HOME/.config/sesh"

# YAZI
backup_and_symlink_dir "$DOTFILES_DIR/.config/yazi" "$HOME/.config/yazi"

# -------------------------------------------------------
# OH-MY-ZSH
# -------------------------------------------------------
# Check if oh-my-zsh is installed. If so, update it. If not, install it.
if [ -d "$HOME/.oh-my-zsh" ]; then
    echo "oh-my-zsh is already installed. Updating..."
    cd "$HOME/.oh-my-zsh" && git pull
else
    echo "Installing oh-my-zsh..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# -------------------------------------------------------
# ZSH-PLUGINS
# -------------------------------------------------------
# Check if zsh plugins directories exist. If so, update them. If not, install them.
ZSH_CUSTOM=${ZSH_CUSTOM:-~/.oh-my-zsh/custom}

# zsh-autosuggestions
if [ -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    echo "zsh-autosuggestions is already installed. Updating..."
    cd "$ZSH_CUSTOM/plugins/zsh-autosuggestions" && git pull
else
    echo "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    echo "zsh-syntax-highlighting is already installed. Updating..."
    cd "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" && git pull
else
    echo "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
fi

# zsh-better-npm-completion
if [ -d "$ZSH_CUSTOM/plugins/zsh-better-npm-completion" ]; then
    echo "zsh-better-npm-completion is already installed. Updating..."
    cd "$ZSH_CUSTOM/plugins/zsh-better-npm-completion" && git pull
else
    echo "Installing zsh-better-npm-completion..."
    git clone https://github.com/lukechilds/zsh-better-npm-completion "$ZSH_CUSTOM/plugins/zsh-better-npm-completion"
fi

# zsh-nvm
if [ -d "$ZSH_CUSTOM/plugins/zsh-nvm" ]; then
    echo "zsh-nvm is already installed. Updating..."
    cd "$ZSH_CUSTOM/plugins/zsh-nvm" && git pull
else
    echo "Installing zsh-nvm..."
    git clone https://github.com/lukechilds/zsh-nvm "$ZSH_CUSTOM/plugins/zsh-nvm"
fi

# -------------------------------------------------------
# MACOS SCRIPTS
# -------------------------------------------------------

/bin/bash "$DOTFILES_DIR/macos/defaults.sh"
/bin/bash "$DOTFILES_DIR/macos/defaults-chrome.sh"

# -------------------------------------------------------
# THE END
# -------------------------------------------------------

echo "✅ Installation complete!"

# Source the .zshrc file to apply changes without requiring a terminal restart
echo "Sourcing .zshrc to apply changes..."
source "$HOME/.zshrc" || echo "Note: You may need to restart your terminal to apply all changes"
