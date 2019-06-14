sudo apt-get update -y
sudo apt-get install -y git
sudo apt-get install -y xterm
sudo apt-get install -y build-essential
sudo apt-get install -y vim
sudo apt install -y copyq
sudo apt install -y curl

# Source all the dotfiles in the repo to the local version
# Make sure to use absolute paths instead of relative ones
ln -s -f ~/git/adamtew/dotfiles/.vimrc ~/.vimrc
ln -s -f ~/git/adamtew/dotfiles/.zshrc ~/.zshrc
ln -s -f ~/git/adamtew/dotfiles/.tmux.conf ~/.tmux.conf

