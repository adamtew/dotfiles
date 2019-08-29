sudo apt-get update -y

# point to mirrors
add-apt-repository ppa:mmstick76/alacritty

cat ubuntu-packages | xargs sudo apt -y install

# Snap packages
snap install --classic heroku
snap install postman
snap install --classic slack

# install dbeaver as a database client

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

# This is a beautiful terminal theme to work with in gnome-terminal
bash -c "$(curl -fsSL https://raw.githubusercontent.com/denysdovhan/gnome-terminal-one/master/one-dark.sh)"

# ###########
# asdf
# ###########
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.2

# Packages:

# Install erlang
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git

export KERL_CONFIGURE_OPTIONS="--disable-debug --without-javac"
asdf install erlang ref:master
asdf global erlang 21.2

# install elixir
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.8.2
asdf global elixir 1.8.2

# install phoenix
mix archive.install https://github.com/phoenixframework/archives/raw/master/phx_new.ez

# ##########
# fzf
# #########
# By running vim plug it will install fzf for you

# when setting up the database, you may need to do this...
grant all privileges on database postgres to postgres;
sudo service postgresql restart
sudo -u postgres psql -c "ALTER USER postgres PASSWORD 'postgres';"


# Tweaks
# gnome-shell-extension-autohidetopbar

