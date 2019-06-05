# brew
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

# oh-my-zsh
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# Use fantasque-sans font in iterm2
# https://github.com/belluzj/fantasque-sans#installation

# material-design-colors in iterm

# tmux plugin manager
# git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# Source all the dotfiles in the repo to the local version
ln -s -f ~/git/adamtew/dotfiles/.vimrc ~/.vimrc
ln -s -f ~/git/adamtew/dotfiles/.zshrc ~/.zshrc
ln -s -f ~/git/adamtew/dotfiles/.tmux.conf ~/.tmux.conf

