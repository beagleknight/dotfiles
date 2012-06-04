#!/bin/bash

if [ -L $HOME/.vim ]; then
  unlink $HOME/.vim
fi
ln -s $HOME/.dotfiles/.vim $HOME

if [ -L $HOME/.vimrc ]; then
  unlink $HOME/.vimrc
fi
ln -s $HOME/.dotfiles/.vimrc $HOME

if [ -L $HOME/.zshrc ]; then
  unlink $HOME/.zshrc
fi
ln -s $HOME/.dotfiles/.zshrc $HOME

if [ -L $HOME/.gitconfig ]; then
  unlink $HOME/.gitconfig
fi
ln -s $HOME/.dotfiles/.gitconfig $HOME
