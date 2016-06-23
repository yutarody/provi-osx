# provi-osx

## My Mac OSX Provisioning

### How to Use

#### First Step
```
xcode-select --install
```
##### ssh-keygen for Access Github
```
ssh-keygen -t rsa -b 4096 -C "yutaro.ver05@gmail.com"
ssh-add ~/.ssh/id_rsa
pbcopy < ~/.ssh/id_rsa.pub
open 'https://github.com/settings/keys'
```

##### Show Hidden Files & Folders
```
defaults write com.apple.finder AppleShowAllFiles -boolean true
killall Finder
```

1. Git clone
```
mkdir $HOME/.repos
git clone --recursive https://github.com/yutarody/provi-osx.git  $HOME/.repos/provi-osx
```
2. Setup zgen include presto
```
zsh
git clone https://github.com/tarjoilija/zgen.git .zgen
zsh $HOME/.repos/provi-osx/setup_zgen.zsh
```

3. Run script
```
sh $HOME/.repos/provi-osx/provi-osx.sh
```

### Referrer
  + [woowee/osx.sh](https://gist.github.com/woowee/6414643)
  + [hnakamu/my-macbook-initial-setup](https://github.com/hnakamur/my-macbook-initial-setup)
