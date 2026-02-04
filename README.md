# dotfiles

## Quick Start

Bootstrap a new machine with a single command:

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/adamtew/dotfiles/master/bootstrap.sh)
```

### What it installs

- **Packages**: git, vim, tmux, zsh, stow, fzf, ag, and more
- **Shell**: Oh-My-Zsh with autosuggestions and syntax-highlighting plugins
- **Configs**: vim, zsh, tmux, git, alacritty (via GNU stow)
- **SSH**: Generates ed25519 key and optionally uploads to GitHub
- **Tools**: GitHub CLI, Claude CLI

### Supported platforms

- macOS
- Debian / Ubuntu

### Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `DOTFILES_DIR` | `~/dotfiles` | Where to clone the dotfiles |
| `BRANCH` | `master` | Git branch to use |

Example with custom directory:
```bash
DOTFILES_DIR=~/my-dotfiles bash <(curl -fsSL https://raw.githubusercontent.com/adamtew/dotfiles/master/bootstrap.sh)
```

### Running locally

If already cloned, run the installer directly:

```bash
./install.sh
```

Options:
- `--skip-packages` - Skip package installation
- `--skip-docker` - Skip Docker installation
- `--skip-ssh` - Skip SSH key setup
- `--skip-claude` - Skip Claude CLI installation

## Post-install

1. **Vim plugins**: Run `:PlugInstall` in vim
2. **Tmux plugins**: Press `<prefix> I` (capital I)
3. **New shell**: Run `exec zsh` or log out and back in

---

## Vim

Started using native packages for [vim-go](https://github.com/fatih/vim-go#install)

```bash
git clone https://github.com/fatih/vim-go.git ~/.vim/pack/plugins/start/vim-go
cd ~/.vim/pack/plugins/start/vim-go
git checkout $(git tag -l --sort version:refname | grep -v rc | tail -1)
vim -c ":helptags ALL" -c ":q"
vim -c ":GoInstallBinaries" -c ":q"
```

## Tmux

This uses tmux plugin manager ([TPM](https://github.com/tmux-plugins/tpm)).

Install plugins with `<prefix> I` (capital __I__)

## Arch or Manjaro

```bash
############## Essentials ##############
sudo pacman -Syy # this will update your package manager
echo 'setxbmap -option caps:swapescape' >> ~/.profile # set caps to escape

# Environment
sudo pacman -Syu zsh # Installs zsh # Took forever becaue it upgraded everything on arch
sudo pacman -S fzf
sudo pacman -S vim
sudo pacman -S tmux --noconfirm

# Code
sudo pacman -S dotnet-runtime
sudo pacman -S dotnet-sdk
sudo pacman -S go
# Might wany to put asdf here to manage nodejs
sudo pacman -S nodejs npm

# Utilities
sudo pacman -S docker
sudo pacman -S docker-compose
sudo pacman -S gnu-netcat # nc
sudo pacman -S make
sudo pacman -S the_silver_searcher # :Ag in vim
sudo snap install slack

# Services
systemctl start docker.service # This starts the service
sudo usermod -aG docker cheese # This makes the service work without running `sudo`

```
