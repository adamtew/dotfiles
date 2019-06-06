# General setting
# Keyboard speed to max in the mac keyboard settings

# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew bundle # in this folder

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Use fantasque-sans font in iterm2
# https://github.com/belluzj/fantasque-sans#installation

# colors for iterm: material-design-colors

# Source all the dotfiles in the repo to the local version
ln -s -f ~/git/adamtew/dotfiles/.vimrc ~/.vimrc
ln -s -f ~/git/adamtew/dotfiles/.zshrc ~/.zshrc
ln -s -f ~/git/adamtew/dotfiles/.tmux.conf ~/.tmux.conf


# Setting up git
ln -s -f ~/git/adamtew/dotfiles/.gitignore ~/.gitignore
git config --global core.excludesfile ~/.gitignore

# Setting up Heroku
heroku login
