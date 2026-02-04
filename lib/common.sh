#!/usr/bin/env bash
# common.sh - Shared functions for dotfiles setup

# Source guard - prevent multiple sourcing
[[ -n "${_COMMON_SH_LOADED:-}" ]] && return 0
_COMMON_SH_LOADED=1

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${GREEN}[INFO]${NC} $*"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_step() {
    echo -e "${BLUE}[STEP]${NC} $*"
}

# OS detection
detect_os() {
    case "$(uname -s)" in
        Darwin)
            echo "macos"
            ;;
        Linux)
            if [ -f /etc/os-release ]; then
                . /etc/os-release
                case "$ID" in
                    ubuntu|debian)
                        echo "debian"
                        ;;
                    *)
                        if [ -n "$ID_LIKE" ]; then
                            case "$ID_LIKE" in
                                *debian*)
                                    echo "debian"
                                    ;;
                                *)
                                    echo "unknown"
                                    ;;
                            esac
                        else
                            echo "unknown"
                        fi
                        ;;
                esac
            else
                echo "unknown"
            fi
            ;;
        *)
            echo "unknown"
            ;;
    esac
}

# User confirmation prompt
confirm() {
    local prompt="${1:-Are you sure?}"
    local default="${2:-n}"

    if [ "$default" = "y" ]; then
        prompt="$prompt [Y/n] "
    else
        prompt="$prompt [y/N] "
    fi

    read -r -p "$prompt" response
    response="${response:-$default}"

    case "$response" in
        [yY][eE][sS]|[yY])
            return 0
            ;;
        *)
            return 1
            ;;
    esac
}

# Check if command exists
command_exists() {
    command -v "$1" &>/dev/null
}

# Ensure running as non-root (for most operations)
ensure_not_root() {
    if [ "$(id -u)" -eq 0 ]; then
        log_error "This script should not be run as root"
        exit 1
    fi
}

# Get the dotfiles directory (default: ~/dotfiles)
get_dotfiles_dir() {
    echo "${DOTFILES_DIR:-$HOME/dotfiles}"
}
