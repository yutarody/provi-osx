#!/usr/bin/env zsh

#Homebrew setup
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#dotfiles clone
git clone https://github.com/yutarody/dotfiles.git

#zgen clone
git clone git@github.com:tarjoilija/zgen.git

#Set up Zgen and the starter kit
zsh
brew install stow
git clone git@github.com:unixorn/zsh-quickstart-kit.git
cd zsh-quickstart-kit
stow --target=$HOME zsh
mkdir $HOME/.zshrc.d
ln -nsf $HOME/dotfiles/001-myset $HOME/.zshrc.d/

#Switch Homebrew zsh
brew install --without-etcdir zsh
echo '/usr/local/bin/zsh' | pbcopy
#insert to shells
sudo vim /etc/shells
#switch homebrew zsh
chsh -s /usr/local/bin/zsh

#reload .zshrc
exec $SHELL -l
exec zsh
