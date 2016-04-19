#!/usr/bin/env bash

#When Error Script Stop
set -e

#Command Line Tools Install Excude Xcode
#xcode-select --install
#echo 'Finish Install Command Line Tools,Press Enter Key'
#read wait

#root
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#Password
echo 'Enter Acount Password:'
read ans

#init directory
mkdir -p $HOME/.temp
#mkdir -p $HOME/.repos
tmp="$HOME/.temp"
repos="$HOME/.repos"

#NAS Mount CHk
MOUNT_CHECK=`df | grep /Volumes/Data$  | wc -l`
if [[ $MOUNT_CHECK -eq 0 ]]; then
  mkdir /Volumes/Data
  mount_afp "afp://yutaro:$ans@192.168.1.1/Data" /Volumes/Data
fi

#Applications
#Server path
install_mediaencorder() {
  echo 'Start the installation of Adobe Media Encorder'
  serverdata='/Volumes/Data/Appz'
  dmg_file="$serverdata/Adobe_Media_Encoder_CC/Setup.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/Adobe Media Encoder CC 2015/install.app"
  open "$pkg_file"
  echo 'Manual installation, press any key when you are finished'
  read wait
  hdiutil detach "$mount_dir"
  echo 'Adobe Media Encorder Installed'

  #update
  dmg_file="$serverdata/Adobe_Media_Encoder_CC/Update.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/AdobePatchInstaller.app"
  open "$pkg_file"
  echo 'Manual Install to end return any keys'
  read wait
  hdiutil detach "$mount_dir"
  echo 'Adobe Media Encorder Updated'

  #etc
  sudo sh $serverdata/Adobe_Media_Encoder_CC/etc/hosts.sh
  echo 'Update Hosts File'
  echo 'Adobe Media Encorder installation is complete'
}

#DAW
#Server path
serverdata='/Volumes/Data/Appz/DAW'

#plug-in directory
##AU
aupath='/Library/Audio/Plug-Ins/Components'
##VST
VSTpath='/Library/Audio/Plug-Ins/VST'
##VST3
VST3path='/Library/Audio/Plug-Ins/VST3'
#cache
cache="$HOME/Library/Caches"

#Logic
install_logic() {
  echo 'Start the installation of Logic X'
  dmg_file="$serverdata/apple/Logic Pro X 10.2.2.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/Logic Pro X.app" "/Applications/Logic Pro X.app"
  hdiutil detach "$mount_dir"
  echo 'Logic X installation is complete'
}

#bisa
install_bias() {
  echo 'Start the installation of Bias Desktop'
  pkg_file="$serverdata/bias/BIAS Plugin.pkg"
  sudo installer -pkg "$pkg_file" -target /
  echo 'Bias Desktop installation is complete'
}

#bozdigital
install_bozdigital() {
  echo 'Start the installation of Boz Digital Bundle'
  pkg_file="$serverdata/bozdigital/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  echo 'Boz Digital Bundle installation is complete'
}

#Effectrix
install_effectrix() {
  echo 'Start the installation of Effectrix'
  dmg_file="$serverdata/effectrix/Effectrix.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/Effectrix.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
  echo 'Effectrix installation is complete'
}

#BFD
install_bfd() {
  echo 'Start the installation of BFD3'
  pkg_file="$serverdata/fxpansion/BFD3_3-1-3-5_Update/BFD3 Installer OSX.app"
    open "$pkg_file"
    echo 'Manual installation, press any key when you are finished'
    read wait
    echo 'BFD3 installation is complete,You Must be Set Library Path'
}

#iZotope
install_iZotope() {
  echo 'Start the installation of iZotope Bundle'
  pkg_file="$serverdata/iZotope/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  open "$serverdata/iZotope/Install iZotope Ozone 7 Advanced.app"
  echo 'Manual installation, press any key when you are finished'
  read wait
  echo 'iZotope etc Task Start'
  sudo installer -pkg "$serverdata/iZotope/etc/etc.mpkg" -target /
  sudo cp -pr $serverdata/iZotope/etc/*.component $aupath/
  sudo cp -pr $serverdata/iZotope/etc/*.vst $VSTpath/
  sudo cp -pr $serverdata/iZotope/etc/*.vst3 $VST3path/
  echo 'iZotope Bundle installation is complete'
}

#PodFarm
install_podfarm() {
  echo 'Start the installation of Pod Farm'
  dmg_file="$serverdata/Line6/PODFarm2.58.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/POD Farm 2.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
  echo 'Pod Farm etc Task Start'
  sudo rsync -av $serverdata/Line6/etc/L6TWXY.framework /Library/Frameworks
  echo 'Pod Farm installation is complete'
}

#LiquidSonics
install_LiquidSonics() {
  echo 'Start the installation of LiquidSonics'
  pkg_file="$serverdata/LiquidSonics/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  #open $serverdata/LiquidSonics/etc/License.lic
  echo 'LiquidSonics installation is complete'
}

#Pianoteq
install_pianoteq() {
  echo 'Start the installation of pianoteq'
  pkg_file="$serverdata/Modartt/Install Pianoteq 5 STAGE.app"
  open "$pkg_file"
  echo 'Manual installation, press any key when you are finished'
  read wait  echo 'Logic X installation is complete'
  echo 'pianoteq installation is complete'
}

#Nugen Audio
install_nugenaudio() {
  echo 'Start the installation of Nugen Audio'
  pkg_file="$serverdata/nugenaudio/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  echo 'Nugen Audio installation is complete'
}

#overloud
install_overloud() {
  echo 'Start the installation of overloud'
  pkg_file="$serverdata/overloud/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done

  sudo cp -pr $serverdata/overloud/etc/*.component $aupath/
  sudo cp -pr $serverdata/overloud/etc/*.vst $VSTpath/
  sudo /usr/bin/ditto "$serverdata/overloud/etc/BREVERB 2.app" "/Applications/BREVERB 2.app"
  echo 'overloud installation is complete'
}

#peavey
install_peavey() {
  echo 'Start the installation of peavey'
  pkg_file="$serverdata/peavey/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  echo 'peavey installation is complete'
}

#PluginAlliance
install_PluginAlliance() {
  echo 'Start the installation of PluginAlliance'
  sudo cp -pr $serverdata/PluginAlliance/AU/* $aupath/
  sudo cp -pr $serverdata/PluginAlliance/VST/* $VSTpath/
  sudo cp -pr $serverdata/PluginAlliance/VST3/* $VST3path/
  cp -pr "$serverdata/PluginAlliance/Applications/Plugin Alliance" /Applications
  echo 'PluginAlliance installation is complete'
}

#presonus
install_presonus() {
  echo 'Start the installation of Studio One'
  dmg_file="$serverdata/presonus/PreSonus - Studio One 3 Professional v3.2.0.36707 OS X.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/Studio One 3.app" "/Applications/Studio One 3.app"
  hdiutil detach "$mount_dir"
  echo 'Studio One installation is complete'
}

#PSPaudioware
install_psp() {
  echo 'Start the installation of PSPaudioware'
  pkg_file="$serverdata/PSPaudioware/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  echo 'PSPaudioware installation is complete'
}

#RedWirez
install_redwirez() {
  echo 'Start the installation of redwirez'
  pkg_file="$serverdata/RedWirez/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  echo 'redwirez installation is complete'
}

#samplemagic
install_samplemagic() {
  echo 'Start the installation of MagicAB'
  dmg_file="$serverdata/samplemagic/MagicAB-AU.dmg"
  for dmg_files in $dmg_file
  do
    mount_dir=`hdiutil attach "$dmg_files" | awk -F '\t' 'END{print $NF}'`
    pkg_file="$mount_dir/Magic AB AU.component"
    sudo cp -pr "$pkg_file" $aupath/
    hdiutil detach "$mount_dir"
  done
  echo 'MagicAB installation is complete'
}

#soundtoys
install_soundtoys() {
  echo 'Start the installation of soundtoys'
  pkg_file="$serverdata/soundtoys/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  echo 'soundtoys installation is complete'
}

#steinberg cubase elements 8
install_cubase() {
  echo 'Start the installation of Cubase'
  dmg_file="$serverdata/steinberg/Cubase_8_Elements/*.dmg"
  for dmg_files in $dmg_file
  do
    mount_dir=`hdiutil attach "$dmg_files" | awk -F '\t' 'END{print $NF}'`
    echo $mount_dir
    if [[ $mount_dir == '/Volumes/License' ]]; then
      echo "Manual Run Steinberg.command:Important!!!After Run SO match High CPU Usage!!!"
      read wait
      open $mount_dir/Steinberg.command
    else
      pkg_file="$mount_dir/Cubase LE AI Elements 8 for Mac OS X/Cubase LE AI Elements 8.pkg"
      sudo installer -pkg "$pkg_file" -target /
    fi

    hdiutil detach "$mount_dir"
  done
  echo 'Cubase installation is complete'
}

#ValhallaDSP
install_valhallaDSP() {
  echo 'Start the installation of valhallaDSP'
  sudo cp -pr $serverdata/ValhallaDSP/*.component $aupath/
  sudo cp -pr $serverdata/ValhallaDSP/*.vst $VSTpath/
  sudo rsync -a "$serverdata/ValhallaDSP/Library/Audio/Presets/Valhalla DSP, LLC" /Library/Audio/Presets
  echo 'valhallaDSP installation is complete'
}

#vocaloid
install_vocaloid() {
  #app installer
  echo 'Start the installation of vocaloid'
  image_file="$serverdata/vocaloid/*.cdr"
  for image_files in $image_file
  do
    mount_dir=`hdiutil attach "$image_files" | awk -F '\t' 'END{print $NF}'`

    #japanese
    if [[ $mount_dir == '/Volumes/HATSUNE MIKU V3 Mac' ]]; then
      #Original
      pkg_file="$mount_dir/SOFTWARE/MIKU_V3_Original/MIKU V3 Original Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

      #Dark
      pkg_file="$mount_dir/SOFTWARE/MIKU_V3_Dark/MIKU V3 Dark Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

      #Soft
      pkg_file="$mount_dir/SOFTWARE/MIKU_V3_Soft/MIKU V3 Soft Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

      #Solid
      pkg_file="$mount_dir/SOFTWARE/MIKU_V3_Solid/MIKU V3 Solid Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

      #Sweet
      pkg_file="$mount_dir/SOFTWARE/MIKU_V3_Sweet/MIKU V3 Sweet Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

      #Piapro
      pkg_file="$mount_dir/SOFTWARE/Piapro_Studio/Piapro Studio Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

      #vocaloid API
      pkg_file="$mount_dir/SOFTWARE/API_Mac_V3_0_1_14/VOCALOID API V3.0.1.14 Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /

    #english
    else
      pkg_file="$mount_dir/Mac/SOFTWARE/MIKU_V3_English/MIKU V3 English Installer.pkg"
      sudo installer -pkg "$pkg_file" -target /
    fi

    hdiutil detach "$mount_dir"
  done

  #pkg installer
  image_file="$serverdata/vocaloid/*.dmg"
  for image_files in $image_file
  do
    mount_dir=`hdiutil attach "$image_files" | awk -F '\t' 'END{print $NF}'`
    #echo $mount_dir
    pkg_file=`sudo find "$mount_dir" -name "*.pkg"`
    #echo $pkg_file
    sudo installer -pkg "$pkg_file" -target /
    hdiutil detach "$mount_dir"
  done

  #piapro studio update
  open "$serverdata/vocaloid/piaprostudio_updater_v2039_Mac/Update.app"
  echo 'vocaloid installation is complete'
}

#vocaloid for cubase neo
install_vocaloidforcubase() {
  echo 'Start the installation of vocaloid for cubase Neo'
  dmg_file="$serverdata/yamaha/Vocaloid for Cubase.cdr"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/VOCALOID Editor for Cubase Installer.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
  echo 'vocaloid for cubase Neo installation is complete'
}

#waves
install_waves() {
  echo 'Start the installation of Waves'
  #Install From Waves Central
  open '/Applications/Waves Central.app'
  echo "Please Manual Install
        - Mercury
        - Abbey Road Collection
        - SSL 4000 Collection
        - GTR Solo (Optional. Full GTR is included in Mercury)
        - WavesTune LT (Optional. Full WavesTune is included in Mercury)"
  read wait
  #etc
  image_file="$serverdata/waves/WavesLicenseEngine.dmg"
  for image_files in $image_file
  do
    mount_dir=`hdiutil attach "$image_files" | awk -F '\t' 'END{print $NF}'`
    pkg_file="$mount_dir/WavesLicenseEngine.pkg"
    sudo installer -pkg "$pkg_file" -target /
    hdiutil detach "$mount_dir"
  done
  open "/Applications/Waves/WaveShells V9/Waves AU Reg Utility 9.6.app"
  echo 'Waves installation is complete'
}

#Spectrasonics
##trilian
install_trilian() {
  echo 'Start the installation of trilian'
  #install software
  pkg_file="$serverdata/Spectrasonics/Trilian Software1.4.3d.pkg"
  sudo installer -pkg "$pkg_file" -target /
  echo "Before Provisioning Trilian"
  read wait
  #update Soundsource
  pkg_file="$serverdata/Spectrasonics/Trilian_Soundsource_Library_Update_1_0_1/Mac/Trilian Soundsource Library.pkg"
  sudo installer -pkg "$pkg_file" -target /
  #update patch
  pkg_file="$serverdata/Spectrasonics/Trilian_Patch_Library_Update_1_4_0/Mac/Trilian Patch Library.pkg"
  sudo installer -pkg "$pkg_file" -target /
  echo 'trilian installation is complete'
}

##Omnisphere 2
install_omnisphere2() {
  echo 'Start the installation of omnisphere2'
  echo 'Before Provisioning Omnisphere 2'
  read wait
  #install software v2.0.3
  pkg_file="$serverdata/Spectrasonics/Omnisphere2/01_Installer/Mac/Omnisphere 2 Installer.pkg"
  sudo installer -pkg "$pkg_file" -target /
  #update Soundsource
  pkg_file="$serverdata/Spectrasonics/Omnisphere2/02_Data_Updater/Mac/Omnisphere_Data_Updater.pkg"
  sudo installer -pkg "$pkg_file" -target /
  #update patch
  pkg_file="$serverdata/Spectrasonics/Omnisphere2/03_For_Trilian_Users/Mac/Trilian Patch Library Update.pkg"
  #etc 2.0.3d
  sudo cp -pr $serverdata/Spectrasonics/Omnisphere2/05_etc/Omnisphere_2.0.3d/*.component $aupath/
  sudo cp -pr $serverdata/Spectrasonics/Omnisphere2/05_etc/Omnisphere_2.0.3d/*.vst $VSTpath/
  echo 'omnisphere2 installation is complete'
}

#NativeInstrumens
install_NI() {
  echo 'Start the installation of Native Instruments Bundle'
  nipath="$serverdata/NativeInstruments"
  #Preference Copy
  sudo rsync -a "$nipath/NI_Preference/"* '/Library/Preferences/'
  #rsync -a "$nipath/NI_Preference_users/"* "$HOME/Library/Preferences/"
  #mkdir
  sudo mkdir -p /Applications/Native\ Instruments/{Battery\ 4,Driver,Enhanced\ EQ,FM8,Guitar\ Rig\ 5,Kontakt\ 5,Massive,RC\ 24,Passive\ EQ,RC\ 48,Reaktor\ 6,Replika,Solid\ Bus\ Comp\ FX,Solid\ Dynamics\ FX,Solid\ EQ\ FX,Supercharger,Supercharger\ GT,Transient\ Master\ FX,VC\ 160\ FX,VC\ 2A\ FX,VC\ 76\ FX,Vari\ Comp}

  #for massive,Battery,FM8,Guitar Rig
  sudo mkdir /Applications/Native\ Instruments/Massive/Battery 4.app
  sudo mkdir /Applications/Native\ Instruments/Massive/Massive.app
  sudo mkdir /Applications/Native\ Instruments/FM8/FM8.app
  sudo mkdir /Applications/Native\ Instruments/Guitar\ Rig\ 5/Guitar\ Rig\ 5.app

  #pkg install
  rsync -a $nipath/pkgs/ $tmp
  pkg_file="$tmp/*pkg"
  for pkg_files in $pkg_file
  do
    rsync -a "$pkg_files"
    open "$pkg_files"
  done
  echo 'Manual Install'
  read wait

  #reaktor install
  iso_file="$nipath/reaktor/*.iso"
  for dmg_file in $iso_file
  do
    mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
    sudo installer -pkg "$mount_dir"/*Mac.pkg -target /
    hdiutil detach "$mount_dir"
  done

  #reaktor pkg
  pkg_file="$nipath/reaktor/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done

  #read wait

  #reaktor update
  pkg_file="$nipath/reaktor/update/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done

  rsync -a "$nipath/Service Center" "$HOME/Library/Application Support/Native Instruments/Service Center"

  #etc plug-in
  sudo rsync -a $nipath/etc/AU/ $aupath/
  sudo rsync -a $nipath/etc//VST/ $VSTpath/

  #etc app
  sudo rsync -a "$nipath/etc/app/Battery 4.app" '/Applications/Native Instruments/Battery 4/'
  sudo rsync -a "$nipath/etc/app/FM8.app" '/Applications/Native Instruments/FM8/'
  sudo rsync -a "$nipath/etc/app/Guitar Rig 5.app" '/Applications/Native Instruments/Guitar Rig 5/'
  sudo rsync -a "$nipath/etc/app/Kontakt 5.app" '/Applications/Native Instruments/Kontakt 5/'
  sudo rsync -a "$nipath/etc/app/Massive.app" '/Applications/Native Instruments/Massive/'
  sudo rsync -a "$nipath/etc/app/Reaktor 6.app" '/Applications/Native Instruments/Reaktor 6/'
  echo 'Native Instruments Bundle installation is complete'
}

#defaults set
setup_defaults() {
  echo 'Start set up defaults'
  sh $HOME/.repos/provi-osx/osx-defaults/defaults-write.sh
  read wait
  echo 'defaults set up is complete'
}

#brewfile
setup_homebrew() {
  echo 'Start Setup Homebrew'
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  #Tap cask
  brew tap caskroom/cask
  #Install Homebrew-file
  echo 'Setup Homebrew-file'
  brew install rcmdnk/file/brew-file
  #Init brew-file from Github
  brew file set_repo
  echo 'Install Brew-file'
  brew file install
  echo 'Brew-file Complete'
}

setup_defaults
install_logic
install_bias
install_bozdigital
install_effectrix
install_bfd
install_iZotope
install_podfarm
install_LiquidSonics
install_pianoteq
install_nugenaudio
install_overloud
install_peavey
install_PluginAlliance
install_presonus
install_psp
install_redwirez
install_samplemagic
install_soundtoys
#install_cubase
install_valhallaDSP
install_vocaloid
install_vocaloidforcubase
install_waves
install_trilian
install_omnisphere2
install_NI
install_mediaencorder
setup_homebrew

#mackup
echo 'Start Set up Mackup'
echo 'after Dropbox sync'
echo 'Press Any key'
mackup restore

rm -d $tmp
