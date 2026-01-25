#!/usr/bin/env bash

CURRENT_SCHEME=$(gsettings get org.gnome.desktop.interface color-scheme)
BG_FILE_PATH="$HOME/.local/share/nvim/bgfile"

if [[ "$CURRENT_SCHEME" == "'prefer-dark'" ]]; then
    gsettings set org.gnome.desktop.interface color-scheme 'default'
    dconf write /org/gnome/shell/extensions/user-theme/name "'Orchis-Light'"
    gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Light-compact'
    ./sync_kitty.sh
else
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
    dconf write /org/gnome/shell/extensions/user-theme/name "'Orchis-Dark'"
    gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Dark-compact'
    ./sync_kitty.sh
fi

function reload-tmux () {
  # If running inside tmux:
  # * Leave tmux (detach), run this script and attach again
  if [ -n "$TMUX" ]; then
    session_name=`tmux display-message -p '#S'`
    tmux detach -E "source $XDG_CONFIG_HOME/zsh/.zshrc && tmux attach -t $session_name"
  fi
}
