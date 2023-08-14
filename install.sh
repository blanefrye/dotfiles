#!/bin/bash

cd ~

for file in .bashrc .config .tmux.conf .vim .vimrc .zshrc; do
    ln -s .dotfiles/$file $file
done

cd -
