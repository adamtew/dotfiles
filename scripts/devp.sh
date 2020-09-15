#!/bin/zsh

function devp() {
  num_args=1
  if [[ $# != $num_args ]]; then
    echo "$0: Wrong number of arguments ($# for $num_args)"
    exit 1
  fi

  DIR="$(dirname ~/git/podium/$1)/$1"
  PROJECT=$1

  if [ -d "$DIR" ]; then
    tmux new-window -c $DIR
    tmux split-window -v -c "#{pane_current_path}"
    tmux split-window -h -c "#{pane_current_path}"
    tmux rename-window "$1"
  fi
}

function _devp() {
  _alternative "dirs:project:($(ls ~/git/podium/))"
}
