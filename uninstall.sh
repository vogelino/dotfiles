#!/bin/bash

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES_DIR="$DOTFILES_DIR/packages"

log_info() { echo -e "\033[34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[32m[OK]\033[0m $1"; }
log_error() { echo -e "\033[31m[ERROR]\033[0m $1"; }

unstow_package() {
    local package="$1"

    if [ ! -d "$PACKAGES_DIR/$package" ]; then
        return 0
    fi

    log_info "Unstowing: $package"
    if stow -d "$PACKAGES_DIR" -t "$HOME" -D "$package" 2>&1; then
        log_success "Unstowed: $package"
    else
        log_error "Failed to unstow: $package"
    fi
}

main() {
    log_info "Unstowing all packages..."

    for package_dir in "$PACKAGES_DIR"/*/; do
        package_name=$(basename "$package_dir")
        unstow_package "$package_name"
    done

    log_success "All packages unstowed."
    log_info "Note: oh-my-zsh, zsh plugins, and Homebrew packages were not removed."
}

main "$@"
