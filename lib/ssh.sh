#!/usr/bin/env bash
# ssh.sh - SSH key generation and GitHub setup

_SSH_SH_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$_SSH_SH_DIR/common.sh"

# Generate SSH key (ed25519 - modern, secure)
generate_ssh_key() {
    local key_path="${1:-$HOME/.ssh/id_ed25519}"
    local email="${2:-}"

    if [ -f "$key_path" ]; then
        log_info "SSH key already exists at $key_path"
        if ! confirm "Generate a new key? (existing will be backed up)"; then
            return 0
        fi
        mv "$key_path" "${key_path}.backup.$(date +%Y%m%d%H%M%S)"
        mv "${key_path}.pub" "${key_path}.pub.backup.$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
    fi

    # Ensure .ssh directory exists with correct permissions
    mkdir -p "$HOME/.ssh"
    chmod 700 "$HOME/.ssh"

    # Get email if not provided
    if [ -z "$email" ]; then
        read -r -p "Enter your email for the SSH key: " email
    fi

    log_info "Generating ed25519 SSH key..."
    ssh-keygen -t ed25519 -C "$email" -f "$key_path"

    # Set correct permissions
    chmod 600 "$key_path"
    chmod 644 "${key_path}.pub"

    log_info "SSH key generated at $key_path"
}

# Start ssh-agent and add key
setup_ssh_agent() {
    local key_path="${1:-$HOME/.ssh/id_ed25519}"

    if [ ! -f "$key_path" ]; then
        log_error "SSH key not found at $key_path"
        return 1
    fi

    log_info "Starting ssh-agent..."
    eval "$(ssh-agent -s)"

    log_info "Adding SSH key to agent..."
    ssh-add "$key_path"

    log_info "SSH key added to agent"
}

# Copy public key to clipboard
copy_pubkey_to_clipboard() {
    local key_path="${1:-$HOME/.ssh/id_ed25519.pub}"
    local os
    os="$(detect_os)"

    if [ ! -f "$key_path" ]; then
        log_error "Public key not found at $key_path"
        return 1
    fi

    case "$os" in
        macos)
            pbcopy < "$key_path"
            log_info "Public key copied to clipboard (pbcopy)"
            ;;
        debian)
            # Only try clipboard if DISPLAY is set (GUI environment)
            if [ -n "${DISPLAY:-}" ]; then
                if command_exists xclip; then
                    xclip -selection clipboard < "$key_path" 2>/dev/null && \
                        log_info "Public key copied to clipboard (xclip)" && return 0
                elif command_exists xsel; then
                    xsel --clipboard < "$key_path" 2>/dev/null && \
                        log_info "Public key copied to clipboard (xsel)" && return 0
                fi
            fi
            # Fallback: print the key
            log_info "Your public key:"
            echo ""
            cat "$key_path"
            echo ""
            ;;
        *)
            log_info "Your public key:"
            echo ""
            cat "$key_path"
            echo ""
            ;;
    esac
}

# Add SSH key to GitHub via gh CLI
add_key_to_github() {
    local key_path="${1:-$HOME/.ssh/id_ed25519.pub}"
    local key_title="${2:-$(hostname)}"

    if [ ! -f "$key_path" ]; then
        log_error "Public key not found at $key_path"
        return 1
    fi

    if ! command_exists gh; then
        log_error "GitHub CLI (gh) not installed"
        log_info "Install it first or manually add your key at https://github.com/settings/keys"
        return 1
    fi

    # Check if gh is authenticated
    if ! gh auth status &>/dev/null; then
        log_info "Authenticating with GitHub..."
        gh auth login
    fi

    log_info "Adding SSH key to GitHub..."
    gh ssh-key add "$key_path" --title "$key_title"

    log_info "SSH key added to GitHub successfully"
}

# Full SSH setup flow
setup_ssh() {
    local email="${1:-}"
    local key_path="$HOME/.ssh/id_ed25519"

    log_step "Setting up SSH..."

    # Generate key
    generate_ssh_key "$key_path" "$email"

    # Setup agent
    setup_ssh_agent "$key_path"

    # Copy to clipboard
    copy_pubkey_to_clipboard "${key_path}.pub"

    # Offer to add to GitHub
    if command_exists gh; then
        if confirm "Add this SSH key to your GitHub account?"; then
            add_key_to_github "${key_path}.pub"
        fi
    else
        log_info "GitHub CLI not installed. Add your key manually at https://github.com/settings/keys"
    fi

    # Test connection
    if confirm "Test SSH connection to GitHub?"; then
        log_info "Testing GitHub SSH connection..."
        ssh -T git@github.com 2>&1 || true
    fi

    log_info "SSH setup complete"
}
