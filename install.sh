#!/bin/sh

serverdata='/Volumes/Data/Appz/DAW'
mkdir -p ~/.temp
tmp='/Users/yutaro/.temp'

#dmg>app install_dmg_app $PATH $APP
install_dmg_app() {
  dmg_file="$serverdata/$1"
  rync -avz $dmg_file $tmp
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/$2" "/Applications/$2"
  hdiutil detach "$mount_dir"
  echo "$3 Install Successed"
}

#pkg only $PATH
install_pkg() {
  rsync -avz "$serverdata/$1" $tmp
  pkg_name=`ls $tmp`
  pkg_file="$tmp/$pkg_file"
  sudo installer -pkg "$pkg_file" -target /
  echo "$2 Install Successed"
}

#Logic
version='10.2.2'
path="apple/Logic Pro X $version.dmg"
appname='Logic Pro X.app'
#install_dmg_app "$path" "$appname"

#bias
version=''
path="bias/BIAS Plugin.pkg"
appname='Positive Grid BIAS Professional'
install_pkg "$path" "$appname"

#rm -d ~/.temp
