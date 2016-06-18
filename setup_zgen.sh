#!/usr/bin/env zsh

#Homebrew setup
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh
brew install stow

#Switch Homebrew zsh
echo '/usr/local/bin/zsh' | pbcopy
#insert to shells
sudo vim /etc/shells
#switch homebrew zsh
chsh -s /usr/local/bin/zsh

#reload .zshrc
exec zsh

#dotfiles clone
git clone https://github.com/yutarody/dotfiles.git

#Set up Zgen and the starter kit
git clone git@github.com:unixorn/zsh-quickstart-kit.git
cd zsh-quickstart-kit
stow --target=$HOME zsh
ln -nsf $HOME/dotfiles/001-myset $HOME/.zshrc.d/

#reload .zshrc
exec $SHELL -l
exec zsh
