#!/usr/bin/env zsh

#Homebrew setup
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install zsh
brew install stow

#Switch Homebrew zsh
echo '/usr/local/bin/zsh' | pbcopy
#insert to shells
sudo vim /etc/shells
chsh -s /usr/local/bin/zsh

#zgen clone
git clone git@github.com:tarjoilija/zgen.git
#important!!!must replace my init.zsh
git clone https://github.com/yutarody/dotfiles.git
ln -nsf $HOME/dotfiles/init.zsh $HOME/.zgen/init.zsh
ln -nsf $HOME/dotfiles/001-myset $HOME/.zshrc.d/

#Set up Zgen and the starter kit
git clone git@github.com:unixorn/zsh-quickstart-kit.git
cd zsh-quickstart-kit
stow --target=$HOME zsh

#reboot shell
exec $SHELL -l
