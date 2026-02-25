#!/bin/bash

DOTFILES="$HOME/.dotfiles"

# Symlink a file/directory, backing up any existing non-symlink target
link() {
    local src="$1"
    local dest="$2"

    if [ -L "$dest" ]; then
        rm "$dest"
    elif [ -e "$dest" ]; then
        echo "Backing up $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -s "$src" "$dest"
    echo "Linked $dest -> $src"
}

# Top-level dotfiles
for file in .bashrc .zshrc .vimrc .tmux.conf .vim; do
    link "$DOTFILES/$file" "$HOME/$file"
done

# .config subdirectories (don't symlink all of .config)
mkdir -p "$HOME/.config"
for dir in nvim alacritty htop; do
    link "$DOTFILES/.config/$dir" "$HOME/.config/$dir"
done
