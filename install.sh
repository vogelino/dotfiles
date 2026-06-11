#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages"

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

log_info() { echo -e "\033[34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[32m[OK]\033[0m $1"; }
log_warning() { echo -e "\033[33m[WARN]\033[0m $1"; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $1"; }

# ============================================================================
# HOMEBREW
# ============================================================================

ask_yes_no() {
    local prompt="$1"
    local response
    while true; do
        read -p "$prompt [y/n]: " response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "Please answer y or n.";;
        esac
    done
}

trust_untrusted_formulae() {
    local brewfile="$1"
    local output
    local untrusted_formulae=()

    # Run brew bundle and capture output to find untrusted formulae
    output=$(brew bundle --file="$brewfile" 2>&1) || true

    # Extract untrusted formulae from the output
    while IFS= read -r line; do
        if [[ "$line" =~ "Refusing to load formula".*"from untrusted tap" ]]; then
            # Extract the formula name (e.g., "drn/tap/nerd-ls")
            formula=$(echo "$line" | grep -oE '[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+')
            if [[ -n "$formula" ]]; then
                untrusted_formulae+=("$formula")
            fi
        fi
    done <<< "$output"

    # If there are untrusted formulae, ask user to trust them
    if [[ ${#untrusted_formulae[@]} -gt 0 ]]; then
        log_warning "The following formulae are from untrusted taps:"
        for formula in "${untrusted_formulae[@]}"; do
            echo "  - $formula"
        done
        echo ""

        if ask_yes_no "Do you want to trust these formulae?"; then
            for formula in "${untrusted_formulae[@]}"; do
                log_info "Trusting $formula..."
                brew trust --formula "$formula"
            done
            return 0  # Signal to retry
        else
            log_warning "Skipping untrusted formulae. Some packages may not be installed."
            return 1  # Signal not to retry
        fi
    fi

    # Check if brew bundle actually failed for other reasons
    if echo "$output" | grep -q "^Error:"; then
        echo "$output"
        return 1
    fi

    return 1  # No untrusted formulae found, don't retry
}

run_brew_bundle() {
    local brewfile="$1"
    local max_retries=10  # Allow up to 10 untrusted taps to be trusted
    local attempt=1

    while [[ $attempt -le $max_retries ]]; do
        if [[ $attempt -eq 1 ]]; then
            log_info "Installing packages from $(basename "$brewfile")..."
        else
            log_info "Retrying $(basename "$brewfile")... (attempt $attempt)"
        fi

        if brew bundle --file="$brewfile" 2>&1; then
            log_success "$(basename "$brewfile") completed successfully"
            return 0
        fi

        # Check for untrusted formulae and ask to trust
        if trust_untrusted_formulae "$brewfile"; then
            ((attempt++))
            continue
        else
            # User declined or no untrusted formulae - don't retry
            break
        fi
    done

    log_warning "brew bundle completed with some packages possibly skipped"
}

install_homebrew() {
    if command -v brew >/dev/null 2>&1; then
        log_info "Homebrew found. Updating..."
        brew update
    else
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi

    run_brew_bundle "$DOTFILES_DIR/install/Brewfile"
    run_brew_bundle "$DOTFILES_DIR/install/Caskfile"
}

# ============================================================================
# STOW
# ============================================================================

ensure_stow() {
    if ! command -v stow >/dev/null 2>&1; then
        log_info "Installing GNU Stow via Homebrew..."
        brew install stow
    fi
}

backup_conflicts() {
    local package="$1"
    local package_dir="$PACKAGES_DIR/$package"

    # Find all files/dirs in the package and check for conflicts
    find "$package_dir" -type f -o -type l | while read -r src; do
        local rel_path="${src#$package_dir/}"
        local dst="$HOME/$rel_path"

        # Check if any parent directory is already a symlink to our package
        # If so, the files inside are already managed by stow, skip them
        local check_path="$HOME"
        local skip=false
        IFS='/' read -ra path_parts <<< "$rel_path"
        for part in "${path_parts[@]}"; do
            check_path="$check_path/$part"
            if [ -L "$check_path" ]; then
                # Parent is a symlink - check if it points to our package
                local link_target
                link_target=$(readlink "$check_path")
                if [[ "$link_target" == *"$package"* ]]; then
                    skip=true
                    break
                fi
            fi
        done

        if [ "$skip" = true ]; then
            continue
        fi

        if [ -e "$dst" ] && [ ! -L "$dst" ]; then
            log_warning "Backing up existing $dst to ${dst}.bak"
            mv "$dst" "${dst}.bak"
        elif [ -L "$dst" ]; then
            local current_target
            current_target=$(readlink "$dst")
            local expected_target="$src"
            if [ "$current_target" != "$expected_target" ]; then
                log_warning "Removing stale symlink $dst"
                rm "$dst"
            fi
        fi
    done
}

stow_package() {
    local package="$1"

    if [ ! -d "$PACKAGES_DIR/$package" ]; then
        log_warning "Package '$package' not found, skipping..."
        return 1
    fi

    log_info "Stowing package: $package"
    backup_conflicts "$package"

    if stow -d "$PACKAGES_DIR" -t "$HOME" -v "$package" 2>&1; then
        log_success "Stowed: $package"
    else
        log_error "Failed to stow: $package"
        return 1
    fi
}

stow_all_packages() {
    # All packages in alphabetical order
    local packages=(
        "gh-dash"
        "git"
        "glow"
        "karabiner"
        "lazygit"
        "lf"
        "npm"
        "nvim"
        "opencode"
        "powerlevel10k"
        "sesh"
        "ssh"
        "surfingkeys"
        "tmux"
        "worktrunk"
        "yazi"
        "zsh"
    )

    # Ensure target directories exist with correct permissions
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    log_info "Stowing packages..."
    for pkg in "${packages[@]}"; do
        stow_package "$pkg"
    done

    # Handle macOS-specific package
    if [ "$(uname -s)" = "Darwin" ]; then
        log_info "Stowing macOS-specific packages..."
        mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
        stow_package "macos"
    fi
}

# ============================================================================
# LOCAL OVERRIDES
# ============================================================================

setup_local_overrides() {
    # Create local override files if they don't exist
    local files=(
        "$DOTFILES_DIR/system/.alias.custom"
        "$PACKAGES_DIR/git/.gitconfig.local"
        "$PACKAGES_DIR/ssh/.ssh/config.local"
    )

    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            log_info "Creating local override: $file"
            touch "$file"
        fi
    done
}

# ============================================================================
# OH-MY-ZSH
# ============================================================================

install_oh_my_zsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "oh-my-zsh found. Updating..."
        (cd "$HOME/.oh-my-zsh" && git pull)
    else
        log_info "Installing oh-my-zsh..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi
}

# ============================================================================
# ZSH PLUGINS
# ============================================================================

install_zsh_plugins() {
    local ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    local plugins=(
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-syntax-highlighting"
        "lukechilds/zsh-better-npm-completion"
    )

    for plugin_url in "${plugins[@]}"; do
        local plugin_name="${plugin_url##*/}"
        local plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"

        if [ -d "$plugin_dir" ]; then
            log_info "Updating $plugin_name..."
            (cd "$plugin_dir" && git pull)
        else
            log_info "Installing $plugin_name..."
            git clone "https://github.com/$plugin_url" "$plugin_dir"
        fi
    done
}

# ============================================================================
# GH EXTENSIONS
# ============================================================================

install_gh_extensions() {
    if ! command -v gh >/dev/null 2>&1; then
        log_warning "GitHub CLI not found, skipping extensions..."
        return
    fi

    while IFS= read -r extension || [ -n "$extension" ]; do
        [[ -z "$extension" || "$extension" == \#* ]] && continue
        local name="${extension##*/}"

        if gh extension list | grep -q "$extension"; then
            log_info "Upgrading gh extension: $name"
            gh extension upgrade "$name"
        else
            log_info "Installing gh extension: $extension"
            gh extension install "$extension"
        fi
    done < "$DOTFILES_DIR/install/GhExtensions"
}

# ============================================================================
# MACOS DEFAULTS
# ============================================================================

apply_macos_defaults() {
    if [ "$(uname -s)" = "Darwin" ]; then
        log_info "Applying macOS defaults..."
        /bin/bash "$DOTFILES_DIR/macos/defaults.sh"
        /bin/bash "$DOTFILES_DIR/macos/defaults-chrome.sh"
    fi
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    log_info "Starting dotfiles installation..."
    log_info "DOTFILES_DIR: $DOTFILES_DIR"

    install_homebrew
    ensure_stow
    setup_local_overrides
    stow_all_packages
    install_oh_my_zsh
    install_zsh_plugins
    install_gh_extensions
    apply_macos_defaults

    log_success "Installation complete!"
    log_info "Please restart your terminal or run: source ~/.zshrc"
}

main "$@"
