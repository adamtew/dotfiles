#!/usr/bin/env bash
# install.sh - Main dotfiles installer
# Run this after bootstrap.sh or directly if dotfiles are already cloned

set -e

# Get script directory (works even if script is sourced)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
export DOTFILES_DIR="${DOTFILES_DIR:-$SCRIPT_DIR}"

# Source libraries
source "$SCRIPT_DIR/lib/common.sh"
source "$SCRIPT_DIR/lib/packages.sh"
source "$SCRIPT_DIR/lib/ssh.sh"

# Parse arguments
SKIP_PACKAGES=false
SKIP_DOCKER=false
SKIP_SSH=false
SKIP_CLAUDE=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --skip-packages)
            SKIP_PACKAGES=true
            shift
            ;;
        --skip-docker)
            SKIP_DOCKER=true
            shift
            ;;
        --skip-ssh)
            SKIP_SSH=true
            shift
            ;;
        --skip-claude)
            SKIP_CLAUDE=true
            shift
            ;;
        --help|-h)
            echo "Usage: $0 [options]"
            echo ""
            echo "Options:"
            echo "  --skip-packages   Skip package installation"
            echo "  --skip-docker     Skip Docker installation"
            echo "  --skip-ssh        Skip SSH key setup"
            echo "  --skip-claude     Skip Claude CLI installation"
            echo "  --help, -h        Show this help message"
            exit 0
            ;;
        *)
            log_warn "Unknown option: $1"
            shift
            ;;
    esac
done

# Install Oh-My-Zsh
install_ohmyzsh() {
    if [ -d "$HOME/.oh-my-zsh" ]; then
        log_info "Oh-My-Zsh already installed"
        return 0
    fi

    log_info "Installing Oh-My-Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

    # Remove the generated .zshrc so stow can symlink ours
    rm -f "$HOME/.zshrc"

    log_info "Oh-My-Zsh installed successfully"
}

# Install Oh-My-Zsh plugins
install_ohmyzsh_plugins() {
    local zsh_custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

    # zsh-autosuggestions
    if [ ! -d "$zsh_custom/plugins/zsh-autosuggestions" ]; then
        log_info "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom/plugins/zsh-autosuggestions"
    fi

    # zsh-syntax-highlighting
    if [ ! -d "$zsh_custom/plugins/zsh-syntax-highlighting" ]; then
        log_info "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom/plugins/zsh-syntax-highlighting"
    fi

    log_info "Oh-My-Zsh plugins installed"
}

# Create required directories
create_directories() {
    log_step "Creating required directories..."

    mkdir -p "$HOME/.config/alacritty"
    mkdir -p "$HOME/.local/bin"

    log_info "Directories created"
}

# Stow all config packages
stow_packages() {
    log_step "Stowing configuration packages..."

    local stow_dir="$DOTFILES_DIR/stow"

    if [ ! -d "$stow_dir" ]; then
        log_error "Stow directory not found: $stow_dir"
        return 1
    fi

    # Ensure stow is installed
    install_stow

    # Get list of packages (directories in stow/)
    local packages
    packages=$(find "$stow_dir" -maxdepth 1 -mindepth 1 -type d -exec basename {} \;)

    for package in $packages; do
        log_info "Stowing $package..."
        stow --restow --dir="$stow_dir" --target="$HOME" "$package" || {
            log_warn "Failed to stow $package - conflicts may exist"
        }
    done

    # Manually link .gitignore (stow ignores it by default)
    if [ -f "$stow_dir/git/.gitignore" ] && [ ! -L "$HOME/.gitignore" ]; then
        log_info "Linking .gitignore (excluded from stow defaults)..."
        ln -sf "$stow_dir/git/.gitignore" "$HOME/.gitignore"
    fi

    log_info "Configuration packages stowed"
}

# Install Claude CLI (native binary)
install_claude_cli() {
    if command_exists claude; then
        log_info "Claude CLI already installed"
        return 0
    fi

    log_info "Installing Claude CLI..."
    curl -fsSL https://claude.ai/install.sh | bash

    log_info "Claude CLI installed"
    log_info "Run 'claude' to authenticate"
}

# Install vim plugins headlessly
install_vim_plugins() {
    log_step "Installing vim plugins..."
    vim +'PlugInstall --sync' +qall
    log_info "Vim plugins installed"
}

# Install tmux plugins headlessly
install_tmux_plugins() {
    log_step "Installing tmux plugins..."

    local tpm_dir="$HOME/.tmux/plugins/tpm"
    if [ ! -d "$tpm_dir" ]; then
        log_info "Cloning TPM..."
        git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    fi

    # TPM's install script queries TMUX_PLUGIN_MANAGER_PATH from the tmux
    # server. Create a temporary session to keep the server alive (tmux 3.4+
    # exits immediately with no sessions) and set the variable.
    tmux new-session -d -s _tpm_install 2>/dev/null || true
    tmux set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins/"
    "$tpm_dir/bin/install_plugins"
    tmux kill-session -t _tpm_install 2>/dev/null || true
    log_info "Tmux plugins installed"
}

# Set zsh as default shell
set_default_shell() {
    local current_shell
    current_shell="$(basename "$SHELL")"

    if [ "$current_shell" = "zsh" ]; then
        log_info "Zsh is already the default shell"
        return 0
    fi

    if ! command_exists zsh; then
        log_warn "Zsh not installed, skipping shell change"
        return 1
    fi

    local zsh_path
    zsh_path="$(which zsh)"

    # Ensure zsh is in /etc/shells
    if ! grep -q "$zsh_path" /etc/shells; then
        log_info "Adding $zsh_path to /etc/shells..."
        echo "$zsh_path" | sudo tee -a /etc/shells
    fi

    log_info "Changing default shell to zsh..."
    chsh -s "$zsh_path"

    log_info "Default shell changed to zsh"
    log_warn "Log out and back in for the change to take effect"
}

# Print completion message
print_completion() {
    echo ""
    echo "========================================"
    echo "  Installation Complete!"
    echo "========================================"
    echo ""
    echo "Next steps:"
    echo "  1. Log out and back in (for shell and group changes)"
    if ! $SKIP_CLAUDE; then
        echo "  2. Run 'claude' to authenticate Claude CLI"
    fi
    echo ""
    echo "Dotfiles location: $DOTFILES_DIR"
    echo ""
}

# Main installation
main() {
    echo ""
    echo "========================================"
    echo "  Dotfiles Installer"
    echo "========================================"
    echo ""

    ensure_not_root

    local os
    os="$(detect_os)"
    log_info "Detected OS: $os"
    log_info "Dotfiles directory: $DOTFILES_DIR"
    echo ""

    # Step 1: Install packages
    if ! $SKIP_PACKAGES; then
        install_packages
        install_gh_cli
    else
        log_info "Skipping package installation"
    fi

    # Step 2: Install Docker
    if ! $SKIP_DOCKER; then
        if confirm "Install Docker?" "n"; then
            install_docker
        fi
    else
        log_info "Skipping Docker installation"
    fi

    # Step 3: Create required directories
    create_directories

    # Step 4: Install Oh-My-Zsh + plugins (before stow so it doesn't overwrite our .zshrc)
    install_ohmyzsh
    install_ohmyzsh_plugins

    # Step 5: Stow configuration packages
    stow_packages

    # Step 6: Install vim and tmux plugins
    install_vim_plugins
    install_tmux_plugins

    # Step 7: Set default shell to zsh
    if confirm "Set zsh as default shell?" "y"; then
        set_default_shell
    fi

    # Step 8: SSH key setup
    if ! $SKIP_SSH; then
        if confirm "Set up SSH key?" "y"; then
            setup_ssh
        fi
    else
        log_info "Skipping SSH setup"
    fi

    # Step 9: Install Claude CLI
    if ! $SKIP_CLAUDE; then
        if confirm "Install Claude CLI?" "y"; then
            install_claude_cli
        fi
    else
        log_info "Skipping Claude CLI installation"
    fi

    # Done
    print_completion
}

main "$@"
