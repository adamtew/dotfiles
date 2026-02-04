#!/usr/bin/env bash
# packages.sh - Package installation functions

_PACKAGES_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_PACKAGES_SH_DIR/common.sh"

# Main package installer - dispatches to OS-specific installer
install_packages() {
    local os
    os="$(detect_os)"

    log_step "Installing packages for $os..."

    case "$os" in
        debian)
            install_debian_packages
            ;;
        macos)
            install_macos_packages
            ;;
        *)
            log_error "Unsupported OS: $os"
            return 1
            ;;
    esac
}

# Install packages on Debian/Ubuntu
install_debian_packages() {
    local dotfiles_dir
    dotfiles_dir="$(get_dotfiles_dir)"
    local packages_file="$dotfiles_dir/packages/ubuntu-apt.txt"

    if [ ! -f "$packages_file" ]; then
        log_error "Package list not found: $packages_file"
        return 1
    fi

    log_info "Updating package lists..."
    sudo apt-get update -y

    log_info "Installing APT packages..."
    # Read packages, ignore comments and empty lines
    grep -v '^#' "$packages_file" | grep -v '^$' | xargs sudo apt-get install -y

    log_info "APT packages installed successfully"
}

# Install packages on macOS using Homebrew
install_macos_packages() {
    local dotfiles_dir
    dotfiles_dir="$(get_dotfiles_dir)"
    local brewfile="$dotfiles_dir/Brewfile"

    # Install Homebrew if not present
    if ! command_exists brew; then
        log_info "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add Homebrew to PATH for Apple Silicon
        if [ -f /opt/homebrew/bin/brew ]; then
            eval "$(/opt/homebrew/bin/brew shellenv)"
        fi
    fi

    if [ -f "$brewfile" ]; then
        log_info "Installing packages from Brewfile..."
        brew bundle --file="$brewfile"
    else
        log_warn "Brewfile not found at $brewfile"
    fi

    log_info "Homebrew packages installed successfully"
}

# Install Docker on Debian/Ubuntu
install_docker_debian() {
    if command_exists docker; then
        log_info "Docker already installed"
        return 0
    fi

    log_info "Installing Docker CE..."

    # Remove old versions
    sudo apt-get remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

    # Install prerequisites
    sudo apt-get install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/$(. /etc/os-release && echo "$ID")/gpg | \
        sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg

    # Set up the repository
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
        https://download.docker.com/linux/$(. /etc/os-release && echo "$ID") \
        $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker
    sudo apt-get update -y
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

    # Add user to docker group
    sudo usermod -aG docker "$USER"

    log_info "Docker installed successfully"
    log_warn "Log out and back in for docker group changes to take effect"
}

# Install Docker on macOS
install_docker_macos() {
    if command_exists docker; then
        log_info "Docker already installed"
        return 0
    fi

    log_info "Installing Docker Desktop via Homebrew..."
    brew install --cask docker

    log_info "Docker Desktop installed - please open it to complete setup"
}

# Install Docker (dispatches to OS-specific installer)
install_docker() {
    local os
    os="$(detect_os)"

    case "$os" in
        debian)
            install_docker_debian
            ;;
        macos)
            install_docker_macos
            ;;
        *)
            log_error "Docker installation not supported on: $os"
            return 1
            ;;
    esac
}

# Install GitHub CLI
install_gh_cli() {
    if command_exists gh; then
        log_info "GitHub CLI already installed"
        return 0
    fi

    local os
    os="$(detect_os)"

    case "$os" in
        debian)
            log_info "Installing GitHub CLI..."
            # Add GitHub CLI repository
            sudo mkdir -p -m 755 /etc/apt/keyrings
            wget -qO- https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
                sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null
            sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg
            echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
                sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
            sudo apt-get update -y
            sudo apt-get install -y gh
            ;;
        macos)
            log_info "Installing GitHub CLI..."
            brew install gh
            ;;
        *)
            log_error "GitHub CLI installation not supported on: $os"
            return 1
            ;;
    esac

    log_info "GitHub CLI installed successfully"
}

# Install stow if not present
install_stow() {
    if command_exists stow; then
        log_info "GNU Stow already installed"
        return 0
    fi

    local os
    os="$(detect_os)"

    case "$os" in
        debian)
            sudo apt-get install -y stow
            ;;
        macos)
            brew install stow
            ;;
        *)
            log_error "Stow installation not supported on: $os"
            return 1
            ;;
    esac

    log_info "GNU Stow installed successfully"
}
