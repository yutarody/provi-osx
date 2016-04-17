#!/usr/bin/env zsh

git clone --recursive https://yutarody@github.com/yutarody/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

#add olignal upstream
cd "${ZDOTDIR:-$HOME}/.zprezto"
git remote add upstream https://github.com/sorin-ionescu/prezto.git
cd $HOME

setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N)
do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

chsh -s /bin/zsh
