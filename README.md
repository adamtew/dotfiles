# dotfiles

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

