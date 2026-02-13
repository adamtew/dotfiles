#!/usr/bin/env bash
# bootstrap.sh - Curl-able entry point for dotfiles setup
# Usage: bash <(curl -fsSL https://raw.githubusercontent.com/adamtew/dotfiles/master/bootstrap.sh)

set -e

# Configuration
DOTFILES_REPO="https://github.com/adamtew/dotfiles.git"
DOTFILES_DIR="${DOTFILES_DIR:-$HOME/dotfiles}"
BRANCH="${BRANCH:-master}"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m'

log_info() { echo -e "${GREEN}[INFO]${NC} $*"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC} $*"; }
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }

# Detect OS
detect_os() {
    case "$(uname -s)" in
        Darwin) echo "macos" ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian) echo "debian" ;;
                    *)
                        if [[ "$ID_LIKE" == *debian* ]]; then
                            echo "debian"
                        else
                            echo "unknown"
                        fi
                        ;;
                esac
            else
                echo "unknown"
            fi
            ;;
        *) echo "unknown" ;;
    esac
}

# Install git if missing
install_git() {
    if command -v git &>/dev/null; then
        log_info "Git already installed"
        return 0
    fi

    local os
    os="$(detect_os)"

    log_info "Installing git..."

    case "$os" in
        macos)
            # Trigger Xcode Command Line Tools installation
            xcode-select --install 2>/dev/null || true
            # Wait for installation
            until command -v git &>/dev/null; do
                log_info "Waiting for Xcode Command Line Tools installation..."
                sleep 5
            done
            ;;
        debian)
            sudo apt-get update -y || log_warn "Some repositories failed to update (continuing anyway)"
            sudo apt-get install -y git
            ;;
        *)
            log_error "Unsupported OS for git installation"
            exit 1
            ;;
    esac

    log_info "Git installed successfully"
}

# Clone or update dotfiles repository
clone_dotfiles() {
    if [ -d "$DOTFILES_DIR/.git" ]; then
        log_info "Dotfiles already cloned at $DOTFILES_DIR"
        log_info "Pulling latest changes..."
        git -C "$DOTFILES_DIR" pull origin "$BRANCH"
    else
        if [ -d "$DOTFILES_DIR" ]; then
            log_warn "$DOTFILES_DIR exists but is not a git repo"
            log_warn "Backing up to ${DOTFILES_DIR}.backup"
            mv "$DOTFILES_DIR" "${DOTFILES_DIR}.backup.$(date +%Y%m%d%H%M%S)"
        fi

        log_info "Cloning dotfiles to $DOTFILES_DIR..."
        git clone --branch "$BRANCH" "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
}

# Main
main() {
    echo ""
    echo "========================================"
    echo "  Dotfiles Bootstrap"
    echo "========================================"
    echo ""

    local os
    os="$(detect_os)"

    if [ "$os" = "unknown" ]; then
        log_error "Unsupported operating system"
        log_error "This script supports macOS and Debian-based Linux (Ubuntu, Debian)"
        exit 1
    fi

    log_info "Detected OS: $os"
    log_info "Dotfiles directory: $DOTFILES_DIR"
    log_info "Branch: $BRANCH"
    echo ""

    # Install git if needed
    install_git

    # Clone/update dotfiles
    clone_dotfiles

    # Hand off to install.sh
    log_info "Running installer..."
    exec "$DOTFILES_DIR/install.sh" "$@"
}

main "$@"
