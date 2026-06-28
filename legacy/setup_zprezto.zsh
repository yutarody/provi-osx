#!/usr/bin/env zsh

git clone --recursive https://yutarody@github.com/yutarody/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"

#add olignal upstream
cd "${ZDOTDIR:-$HOME}/.zprezto"
git remote add upstream https://github.com/sorin-ionescu/prezto.git
cd $HOME

# 拡張グロブで補完(~とか^とか。例えばless *.txt~memo.txt ならmemo.txt 以外の *.txt にマッチ)
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N)
do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

chsh -s /bin/zsh
