#!/bin/bash

# Don't exit on error - we handle errors explicitly
set +e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages"
BACKUP_TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ============================================================================
# COLORS AND FORMATTING
# ============================================================================

BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
BLUE='\033[34m'
MAGENTA='\033[35m'
CYAN='\033[36m'

# ============================================================================
# UTILITY FUNCTIONS
# ============================================================================

print_header() {
    local title="$1"
    local width=60
    echo ""
    echo -e "${BOLD}${MAGENTA}╔$(printf '═%.0s' $(seq 1 $((width-2))))╗${RESET}"
    printf "${BOLD}${MAGENTA}║${RESET} ${BOLD}%-$((width-4))s${RESET} ${BOLD}${MAGENTA}║${RESET}\n" "$title"
    echo -e "${BOLD}${MAGENTA}╚$(printf '═%.0s' $(seq 1 $((width-2))))╝${RESET}"
    echo ""
}

print_step() {
    echo -e "${CYAN}▶${RESET} ${BOLD}$1${RESET}"
}

print_substep() {
    echo -e "  ${DIM}├─${RESET} $1"
}

print_substep_last() {
    echo -e "  ${DIM}└─${RESET} $1"
}

log_info() {
    echo -e "  ${BLUE}ℹ${RESET} $1"
}

log_success() {
    echo -e "  ${GREEN}✓${RESET} $1"
}

log_warning() {
    echo -e "  ${YELLOW}⚠${RESET} $1"
}

log_error() {
    echo -e "  ${RED}✗${RESET} $1"
}

ask_yes_no() {
    local prompt="$1"
    local response
    while true; do
        read -p "  $prompt [y/n]: " response
        case "$response" in
            [Yy]* ) return 0;;
            [Nn]* ) return 1;;
            * ) echo "  Please answer y or n.";;
        esac
    done
}

is_macos() {
    [ "$(uname -s)" = "Darwin" ]
}

is_linux() {
    [ "$(uname -s)" = "Linux" ]
}

# ============================================================================
# HOMEBREW
# ============================================================================

init_homebrew_path() {
    if command -v brew >/dev/null 2>&1; then
        return 0
    fi

    local brew_paths=(
        "/opt/homebrew/bin/brew"
        "/usr/local/bin/brew"
        "/home/linuxbrew/.linuxbrew/bin/brew"
        "$HOME/.linuxbrew/bin/brew"
    )

    for brew_path in "${brew_paths[@]}"; do
        if [ -x "$brew_path" ]; then
            print_substep "Initializing Homebrew from $brew_path"
            eval "$("$brew_path" shellenv)"
            return 0
        fi
    done

    return 1
}

trust_untrusted_taps() {
    local output="$1"
    local -A trusted_taps=()  # Track what we've already trusted
    local found_untrusted=false

    # Look for "Refusing to load formula X from untrusted tap"
    while IFS= read -r line; do
        if [[ "$line" =~ Refusing\ to\ load\ formula\ ([a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+)\ from\ untrusted ]]; then
            local formula="${BASH_REMATCH[1]}"
            if [[ -n "$formula" && -z "${trusted_taps[$formula]}" ]]; then
                print_substep "Trusting formula: $formula"
                brew trust --formula "$formula" 2>/dev/null || true
                trusted_taps[$formula]=1
                found_untrusted=true
            fi
        fi
    done <<< "$output"

    # Also look for "The following taps are not trusted:" block
    # Extract tap names from lines like "  goles/battery"
    while IFS= read -r line; do
        # Match lines that look like tap names (user/repo format, indented)
        if [[ "$line" =~ ^[[:space:]]+([a-zA-Z0-9_-]+/[a-zA-Z0-9_-]+)[[:space:]]*$ ]]; then
            local tap="${BASH_REMATCH[1]}"
            if [[ -n "$tap" && -z "${trusted_taps[$tap]}" ]]; then
                print_substep "Trusting tap: $tap"
                brew trust "$tap" 2>/dev/null || true
                trusted_taps[$tap]=1
                found_untrusted=true
            fi
        fi
    done <<< "$output"

    if [[ "$found_untrusted" == true ]]; then
        return 0
    fi

    return 1
}

run_brew_bundle() {
    local brewfile="$1"
    local max_retries=10
    local attempt=1
    local output_file
    local exit_code

    output_file=$(mktemp)

    while [[ $attempt -le $max_retries ]]; do
        if [[ $attempt -eq 1 ]]; then
            print_step "Installing packages from $(basename "$brewfile")"
        else
            log_info "Retry attempt $attempt..."
        fi

        brew bundle --file="$brewfile" --verbose 2>&1 | tee "$output_file"
        exit_code=${PIPESTATUS[0]}

        if [[ $exit_code -eq 0 ]]; then
            log_success "$(basename "$brewfile") completed"
            rm -f "$output_file"
            return 0
        fi

        local output
        output=$(cat "$output_file")
        trust_untrusted_taps "$output"
        local trust_result=$?

        if [[ $trust_result -eq 0 ]]; then
            ((attempt++))
            continue
        else
            log_error "$(basename "$brewfile") had errors"
            log_warning "Continuing anyway..."
            rm -f "$output_file"
            return 0
        fi
    done

    log_error "$(basename "$brewfile") failed after $max_retries attempts"
    rm -f "$output_file"
    return 0
}

install_homebrew() {
    print_header "📦 Homebrew & Packages"

    if ! command -v brew >/dev/null 2>&1; then
        print_step "Installing Homebrew"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        if ! init_homebrew_path; then
            log_error "Failed to initialize Homebrew after installation"
            return 1
        fi
        log_success "Homebrew installed"
    else
        print_step "Updating Homebrew"
        brew update
        log_success "Homebrew updated"
    fi

    echo ""
    run_brew_bundle "$DOTFILES_DIR/install/Brewfile"

    if is_macos; then
        echo ""
        run_brew_bundle "$DOTFILES_DIR/install/Caskfile"
    else
        echo ""
        log_info "Skipping Caskfile (macOS only)"
    fi
}

# ============================================================================
# STOW
# ============================================================================

ensure_stow() {
    if ! command -v stow >/dev/null 2>&1; then
        print_substep "Installing GNU Stow"
        brew install stow
    fi
}

backup_conflicts() {
    local package="$1"
    local package_dir="$PACKAGES_DIR/$package"

    find "$package_dir" -type f -o -type l | while read -r src; do
        local rel_path="${src#$package_dir/}"
        local dst="$HOME/$rel_path"

        local check_path="$HOME"
        local skip=false
        IFS='/' read -ra path_parts <<< "$rel_path"
        for part in "${path_parts[@]}"; do
            check_path="$check_path/$part"
            if [ -L "$check_path" ]; then
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
            local backup_path="${dst}.backup_${BACKUP_TIMESTAMP}"
            log_warning "Backing up $dst"
            mv "$dst" "$backup_path"
        elif [ -L "$dst" ]; then
            local current_target
            current_target=$(readlink "$dst")
            local expected_target="$src"
            if [ "$current_target" != "$expected_target" ]; then
                rm "$dst"
            fi
        fi
    done
}

stow_package() {
    local package="$1"

    if [ ! -d "$PACKAGES_DIR/$package" ]; then
        return 1
    fi

    backup_conflicts "$package"

    if stow -d "$PACKAGES_DIR" -t "$HOME" "$package" 2>/dev/null; then
        print_substep "$package"
        return 0
    else
        log_error "Failed: $package"
        return 1
    fi
}

stow_all_packages() {
    print_header "🔗 Symlinking Dotfiles"

    ensure_stow

    local packages=()
    for pkg_dir in "$PACKAGES_DIR"/*/; do
        local pkg_name
        pkg_name=$(basename "$pkg_dir")
        if [[ "$pkg_name" != "macos" ]]; then
            packages+=("$pkg_name")
        fi
    done

    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    print_step "Stowing ${#packages[@]} packages"
    local success_count=0
    for pkg in "${packages[@]}"; do
        if stow_package "$pkg"; then
            ((success_count++))
        fi
    done
    log_success "$success_count packages stowed"

    if is_macos && [ -d "$PACKAGES_DIR/macos" ]; then
        echo ""
        print_step "Stowing macOS-specific configs"
        mkdir -p "$HOME/Library/Application Support/com.mitchellh.ghostty"
        stow_package "macos"
        log_success "macOS configs stowed"
    fi
}

# ============================================================================
# SSH KEY SETUP
# ============================================================================

setup_ssh_key() {
    print_header "🔑 SSH Key Setup"

    local ssh_dir="$HOME/.ssh"
    local key_path="$ssh_dir/id_ed25519"
    local pub_key_path="$key_path.pub"

    mkdir -p "$ssh_dir"
    chmod 700 "$ssh_dir"

    if [ -f "$key_path" ]; then
        log_success "SSH key already exists at $key_path"
        return 0
    fi

    # Check if gum is available
    if ! command -v gum >/dev/null 2>&1; then
        log_warning "gum not installed, using basic prompts"

        echo ""
        echo "An SSH key is required for GitHub authentication and commit signing."
        echo ""

        if ! ask_yes_no "Generate a new SSH key?"; then
            log_warning "Skipping SSH key generation"
            return 0
        fi

        local email=""
        while [ -z "$email" ]; do
            read -p "  Email address: " email
        done

        local name=""
        while [ -z "$name" ]; do
            read -p "  Your name: " name
        done
    else
        echo ""
        gum style \
            --border rounded \
            --border-foreground 212 \
            --padding "1 2" \
            "SSH Key Setup"

        echo ""
        gum format <<EOF
An SSH key is required for:
- **Authenticating** with GitHub
- **Signing** git commits
EOF
        echo ""

        if ! gum confirm "Would you like to generate a new SSH key?"; then
            log_warning "Skipping SSH key generation"
            return 0
        fi

        local email=""
        while [ -z "$email" ]; do
            email=$(gum input --placeholder "you@example.com" --header "Enter your email address:" --char-limit 100)
            email=$(echo "$email" | xargs)  # Trim whitespace
            if [ -z "$email" ]; then
                log_warning "Email cannot be empty, please try again"
                sleep 0.5
            fi
        done

        local name=""
        while [ -z "$name" ]; do
            name=$(gum input --placeholder "Your Name" --header "Enter your name for git commits:" --char-limit 100)
            name=$(echo "$name" | xargs)  # Trim whitespace
            if [ -z "$name" ]; then
                log_warning "Name cannot be empty, please try again"
                sleep 0.5
            fi
        done
    fi

    print_step "Generating SSH key"
    ssh-keygen -t ed25519 -C "$email" -f "$key_path" -N ""

    if [ ! -f "$key_path" ]; then
        log_error "Failed to generate SSH key"
        return 1
    fi

    log_success "SSH key generated"

    print_step "Configuring SSH agent"
    eval "$(ssh-agent -s)" >/dev/null 2>&1
    ssh-add --apple-use-keychain "$key_path" 2>/dev/null || ssh-add "$key_path"
    log_success "Key added to agent"

    print_step "Configuring local files"

    local ssh_config_local="$PACKAGES_DIR/ssh/.ssh/config.local"
    cat > "$ssh_config_local" << EOF
Host *
  IdentityFile ~/.ssh/id_ed25519
EOF
    print_substep "SSH config"

    local git_config_local="$PACKAGES_DIR/git/.gitconfig.local"
    cat > "$git_config_local" << EOF
[user]
	email = $email
	name = $name
	signingkey = ~/.ssh/id_ed25519
EOF
    print_substep_last "Git config"

    # Copy to clipboard on macOS
    if is_macos && command -v pbcopy >/dev/null 2>&1; then
        cat "$pub_key_path" | pbcopy
        log_success "Public key copied to clipboard"
    fi

    echo ""
    if command -v gum >/dev/null 2>&1; then
        gum style \
            --border rounded \
            --border-foreground 212 \
            --padding "1 2" \
            --bold \
            "Add your SSH key to GitHub"

        echo ""
        gum format <<EOF
## Step 1: Add as Authentication Key
1. Go to: https://github.com/settings/ssh/new
2. **Title:** \`$(hostname) ($(date +%Y-%m-%d))\`
3. **Key type:** Authentication Key
4. Paste the key (Cmd+V)
5. Click **Add SSH key**

## Step 2: Add as Signing Key
1. Go to: https://github.com/settings/ssh/new
2. **Title:** \`$(hostname) signing key\`
3. **Key type:** Signing Key
4. Paste the same key
5. Click **Add SSH key**
EOF
    else
        echo -e "${BOLD}Add your SSH key to GitHub:${RESET}"
        echo ""
        echo "  1. Go to: https://github.com/settings/ssh/new"
        echo "  2. Add as Authentication Key"
        echo "  3. Add again as Signing Key"
    fi

    echo ""

    # Show key if not copied
    if ! is_macos || ! command -v pbcopy >/dev/null 2>&1; then
        echo -e "${DIM}Your public key:${RESET}"
        echo ""
        cat "$pub_key_path"
        echo ""
    fi

    if command -v gum >/dev/null 2>&1; then
        gum confirm "Press Enter once you've added the key to GitHub" --affirmative "Continue" --negative "" || true
    else
        read -p "  Press Enter once you've added the key to GitHub..."
    fi

    print_step "Testing GitHub connection"
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
        log_success "GitHub authentication successful"
    else
        log_warning "Could not verify connection (test later with: ssh -T git@github.com)"
    fi
}

# ============================================================================
# LOCAL OVERRIDES
# ============================================================================

setup_local_overrides() {
    local files=(
        "$DOTFILES_DIR/system/.alias.custom"
        "$PACKAGES_DIR/git/.gitconfig.local"
        "$PACKAGES_DIR/ssh/.ssh/config.local"
    )

    for file in "${files[@]}"; do
        if [ ! -f "$file" ]; then
            touch "$file"
        fi
    done
}

# ============================================================================
# OH-MY-ZSH
# ============================================================================

install_oh_my_zsh() {
    print_header "🐚 Shell Setup"

    if [ -d "$HOME/.oh-my-zsh" ]; then
        print_step "Updating oh-my-zsh"
        (cd "$HOME/.oh-my-zsh" && git pull --quiet)
        log_success "oh-my-zsh updated"
    else
        print_step "Installing oh-my-zsh"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        log_success "oh-my-zsh installed"
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

    echo ""
    print_step "Installing ZSH plugins"

    for plugin_url in "${plugins[@]}"; do
        local plugin_name="${plugin_url##*/}"
        local plugin_dir="$ZSH_CUSTOM/plugins/$plugin_name"

        if [ -d "$plugin_dir" ]; then
            (cd "$plugin_dir" && git pull --quiet)
            print_substep "$plugin_name (updated)"
        else
            git clone --quiet "https://github.com/$plugin_url" "$plugin_dir"
            print_substep "$plugin_name (installed)"
        fi
    done

    log_success "${#plugins[@]} plugins ready"
}

# ============================================================================
# GH EXTENSIONS
# ============================================================================

install_gh_extensions() {
    print_header "🐙 GitHub CLI Extensions"

    if ! command -v gh >/dev/null 2>&1; then
        log_warning "GitHub CLI not found, skipping extensions"
        return
    fi

    if [ ! -f "$DOTFILES_DIR/install/GhExtensions" ]; then
        log_info "No GhExtensions file found"
        return
    fi

    print_step "Installing extensions"
    local count=0

    while IFS= read -r extension || [ -n "$extension" ]; do
        [[ -z "$extension" || "$extension" == \#* ]] && continue
        local name="${extension##*/}"

        if gh extension list 2>/dev/null | grep -q "$extension"; then
            gh extension upgrade "$name" 2>/dev/null || true
            print_substep "$name (upgraded)"
        else
            gh extension install "$extension" 2>/dev/null || true
            print_substep "$name (installed)"
        fi
        ((count++))
    done < "$DOTFILES_DIR/install/GhExtensions"

    log_success "$count extensions ready"
}

# ============================================================================
# MACOS DEFAULTS
# ============================================================================

apply_macos_defaults() {
    if ! is_macos; then
        return
    fi

    print_header "🍎 macOS Preferences"

    print_step "Applying system defaults"
    if [ -f "$DOTFILES_DIR/macos/defaults.sh" ]; then
        /bin/bash "$DOTFILES_DIR/macos/defaults.sh"
        log_success "System defaults applied"
    fi

    print_step "Applying Chrome defaults"
    if [ -f "$DOTFILES_DIR/macos/defaults-chrome.sh" ]; then
        /bin/bash "$DOTFILES_DIR/macos/defaults-chrome.sh"
        log_success "Chrome defaults applied"
    fi
}

# ============================================================================
# MAIN
# ============================================================================

print_banner() {
    echo ""
    echo -e "${BOLD}${MAGENTA}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║            ·  D O T F I L E S  ·                      ║
    ║                                                       ║
    ║              Installation Script                      ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
    echo -e "  ${DIM}Directory:${RESET} $DOTFILES_DIR"
    echo -e "  ${DIM}Platform:${RESET}  $(uname -s) ($(uname -m))"
    echo ""
}

print_summary() {
    echo ""
    echo -e "${BOLD}${GREEN}"
    cat << 'EOF'
    ╔═══════════════════════════════════════════════════════╗
    ║                                                       ║
    ║            ✓  Installation Complete!                  ║
    ║                                                       ║
    ╚═══════════════════════════════════════════════════════╝
EOF
    echo -e "${RESET}"
    echo ""
    echo -e "  ${BOLD}Next steps:${RESET}"
    echo -e "  ${DIM}├─${RESET} Restart your terminal"
    echo -e "  ${DIM}├─${RESET} Or run: ${CYAN}exec zsh${RESET}"
    echo -e "  ${DIM}└─${RESET} Enjoy your new setup! 🎉"
    echo ""
}

main() {
    print_banner

    install_homebrew
    setup_ssh_key
    setup_local_overrides
    install_oh_my_zsh      # Must be before stow so our .zshrc overwrites oh-my-zsh's template
    install_zsh_plugins
    stow_all_packages      # Now stow our configs (including .zshrc)
    install_gh_extensions
    apply_macos_defaults

    print_summary
}

main "$@"
