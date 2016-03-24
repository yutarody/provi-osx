#!/bin/sh

#rootで実行
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#DAW

#Serverパス
serverdata='/Volumes/Data/Appz/DAW'

#Logic
install_logic() {
  download_url="$serverdata/apple/Logic Pro X 10.2.2.dmg"
  mount_dir=`hdiutil attach "$download_url" | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/Logic Pro X.app" "/Applications/Logic Pro X.app"
  hdiutil detach "$mount_dir"
}

#install_logic

#bisa
install_bias() {
  pkg_file="$serverdata/bias/BIAS Plugin.pkg"
  sudo installer -pkg $pkg_file -target /
}

#bozdigital
install_bozdigital() {
  pkg_url="$serverdata/bozdigital/*.pkg"
  for pkg_file in $pkg_url
  do
    sudo installer -pkg $pkg_file -target /
  done
}

install_bozdigital
