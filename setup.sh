# General setting
# Keyboard speed to max in the mac keyboard settings

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle # in this folder

# #####################
# ZSH (macOS or Ubuntu)
# #####################
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

# Use fantasque-sans font in iterm2
# https://github.com/belluzj/fantasque-sans#installation

# colors for iterm: material-design-colors

# Source all the dotfiles in the repo to the local version
# Make sure to use absolute paths instead of relative ones
ln -s -f ~/git/adamtew/dotfiles/.vimrc ~/.vimrc
ln -s -f ~/git/adamtew/dotfiles/.zshrc ~/.zshrc
ln -s -f ~/git/adamtew/dotfiles/.tmux.conf ~/.tmux.conf
ln -s -f ~/git/adamtew/dotfiles/alacritty.yml ~/.config/alacritty/alacritty.yml
ln -s -f ~/git/adamtew/dotfiles/.gitconfig ~/.gitconfig

# Setting up git
# Setup personal information
git config --global user.name "name"
git config --global user.email "email"
git config --global core.editor "vim"

#global ignore
ln -s -f ~/git/adamtew/dotfiles/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore

# ssh keys
ssh-keygen -t rsa -b 4096 -C "email"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_rsa
# Copy the contents of the public key to github or gitlab
cat ~/.ssh/id_rsa.pub | xclip -i -selection clipboard

# Setting up Heroku
heroku login

# ############################
# TMUX
# ###########################
# run ctl+x I to fetch and run plugins
