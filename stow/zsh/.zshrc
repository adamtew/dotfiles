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

# Source gruvbox palette if available (macOS)
if [ -f "$HOME/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh" ]; then
    source "$HOME/.vim/plugged/gruvbox/gruvbox_256palette_osx.sh"
fi

# Add local bin to PATH
export PATH="$HOME/.local/bin:$PATH"

export GIT_MERGE_AUTOEDIT=no

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
