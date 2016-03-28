#!/bin/sh

#rootで実行
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#DAW

#Serverパス
serverdata='/Volumes/Data/Appz/DAW'
#plug-in directory
##AU
aupath='/Library/Audio/Plug-Ins/Components'
##VST
VSTpath='/Library/Audio/Plug-Ins/VST'
##VST3
VST3path='/Library/Audio/Plug-Ins/VST3'
#cache
cache='/Users/yutaro/Library/Caches'

#Logic
install_logic() {
  dmg_file="$serverdata/apple/Logic Pro X 10.2.2.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/Logic Pro X.app" "/Applications/Logic Pro X.app"
  hdiutil detach "$mount_dir"
}

#bisa
install_bias() {
  pkg_file="$serverdata/bias/BIAS Plugin.pkg"
  sudo installer -pkg "$pkg_file" -target /
}

#bozdigital
install_bozdigital() {
  pkg_file="$serverdata/bozdigital/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}

#Effectrix
install_effectrix() {
  dmg_file="$serverdata/effectrix/Effectrix.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/Effectrix.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
}

#iZotope
install_iZotope() {
  pkg_file="$serverdata/iZotope/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  open "$serverdata/iZotope/Install iZotope Ozone 7 Advanced.app"
  echo "press any keys continue:"
  read wait
  sudo installer -pkg "$serverdata/iZotope/crack/Crack.mpkg" -target /
  sudo cp -pvr $serverdata/iZotope/crack/*.component $aupath/
  sudo cp -pvr $serverdata/iZotope/crack/*.vst $VSTpath/
  sudo cp -pvr $serverdata/iZotope/crack/*.vst3 $VST3path/
}

#PodFarm
install_podfarm() {
  dmg_file="$serverdata/Line6/POD Farm 2.56.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/POD Farm 2.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
}

#LiquidSonics
install_LiquidSonics() {
  pkg_file="$serverdata/LiquidSonics/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  #open $serverdata/LiquidSonics/crack/License.lic
}

#Pianoteq
install_pianoteq() {
  pkg_file="$serverdata/Modartt/Install Pianoteq 5 STAGE.app/Contents/Resources/Install Pianoteq 5 STAGE.mpkg"
  sudo installer -pkg "$pkg_file" -target /
}

#NativeInstrumens
install_NI() {
  nipath="$serverdata/NativeInstruments"
  #Preference Copy
  sudo cp -v "$nipath/NI_Preference/"* '/Library/Preferences'
  cp -v "$nipath/NI_Preference_users/"* '/Users/yutaro/Library/Preferences'

  #pkg install
  pkg_file="$nipath/pkgs/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done

  #ISO install
  iso_file="$nioath/pkgs/*.iso"
  for dmg_file in $iso_file
  do
    mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
    pkg_file="$mount_dir/*.pkg"
    sudo installer -pkg "$pkg_file" -target /
    hdiutil detach "$mount_dir"
  done
  rsync -avz "$nipath/Service Center" "/Users/yutaro/Library/Application Support/Native Instruments/Service Center"
}

#Nugen Audio
install_nugensudio() {
  pkg_file="$serverdata/nugenaudio/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}

#overloud
install_overloud() {
  pkg_file="$serverdata/overloud/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done

  sudo cp -pvr $serverdata/overloud/crack/*.component $aupath/
  sudo cp -pvr $serverdata/overloud/crack/*.vst $VSTpath/
  sudo /usr/bin/ditto "$serverdata/overloud/crack/BREVERB 2.app" "/Applications/BREVERB 2.app"
}

#peavey
install_peavey() {
  pkg_file="$serverdata/nugenaudio/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}

#PluginAlliance
install_PluginAlliance() {
  sudo cp -pvr "$serverdata/PluginAlliance/AU/*" $aupath/
  sudo cp -pvr "$serverdata/PluginAlliance/VST/*" $VSTpath/
  sudo cp -pvr "$serverdata/PluginAlliance/VST2/*" $VST3path/
  cp -pvr "$serverdata/PluginAlliance/Applications/Plugin Alliance" /Applications
}

#presonus
install_presonus() {
  dmg_file="$serverdata/presonus/PreSonus - Studio One 3 Professional v3.2.0.36707 OS X.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/Studio One 3.app"
  open "$pkg_file"
  hdiutil detach "$mount_dir"
}

#PSPaudioware
install_psp() {
  pkg_file="$serverdata/PSPaudioware/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}

#RedWirez
install_redwirez() {
  pkg_file="$serverdata/RedWirez/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}

#samplemagic
install_samplemagic() {
  dmg_file="$serverdata/samplemagic/MagicAB-AU.dmg"
  for dmg_files in $dmg_file
  do
    mount_dir=`hdiutil attach "$dmg_files" | awk -F '\t' 'END{print $NF}'`
    pkg_file="$mount_dir/Magic AB AU.component"
    sudo cp -pvr $pkg_file $aupath/
  done
}

#soundtoys
install_soundtoys() {
  pkg_file="$serverdata/soundtoys/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}






#Spectrasonics
##trilian
install_trilian() {
  echo "Before install Trilian sounddata"
  read wait
  #install software
  pkg_file="$serverdata/Spectrasonics/Trilian Software1.4.3d.pkg"
  sudo installer -pkg "$pkg_file" -target /
  #update Soundsource
  pkg_file="$serverdata/Spectrasonics/Trilian_Soundsource_Library_Update_1_0_1/Mac/Trilian Soundsource Library.pkg"
  sudo installer -pkg "$pkg_file" -target /
  #update patch
  pkg_file="$serverdata/Spectrasonics/Trilian_Patch_Library_Update_1_4_0/Mac/Trilian Patch Library.pkg"
}
