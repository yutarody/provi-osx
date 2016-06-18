# provi-osx

## My Mac OSX Provisioning
### How to Use
1. Git clone
```
xcode-select --install
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
