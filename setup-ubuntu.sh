sudo apt-get update -y

cat ubuntu-packages | xargs sudo apt -y install

# Source all the dotfiles in the repo to the local version
# Make sure to use absolute paths instead of relative ones
ln -s -f ~/git/adamtew/dotfiles/.vimrc ~/.vimrc
ln -s -f ~/git/adamtew/dotfiles/.zshrc ~/.zshrc
ln -s -f ~/git/adamtew/dotfiles/.tmux.conf ~/.tmux.conf

# Non-code settings:
#
# Using gnome-terminal
# Set the cursor shape to I-beam
# After installing the fantasque font, set it up in preferences
# Set the theme to be something other than the system theme such as solarized dark


# ###########
# asdf
# ###########

