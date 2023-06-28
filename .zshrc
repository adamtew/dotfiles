export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="robbyrussell"
plugins=(
  git
  zsh-autosuggestions
  docker-compose
  fzf
  zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

bindkey '^[;' autosuggest-accept

source $HOME/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh*

export GIT_MERGE_AUTOEDIT=no
