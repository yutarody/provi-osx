#!/bin/sh

#root
sudo -v
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

#init directory
mkdir -p ~/.temp
mkdir -p ~/.repos
tmp='/Users/yutaro/.temp'
repos='Users/yutaro/.repos'

#NAS Mount CHk
MOUNT_CHECK=`df | grep /Volumes/Data$  | wc -l`
if [[ $MOUNT_CHECK -eq 0 ]]; then
  echo 'Enter Password:'
  read ans
  mkdir /Volumes/Data
  mount_afp "afp://yutaro:$ans@192.168.1.1/Data" /Volumes/Data
fi

#Server path
serverdata='/Volumes/Data/Appz/DAW'

#defaults set

#brewfile
brew file install

#dotsfiles(zsh)
git clone --recursive https://yutarody@github.com/yutarody/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
cd "${ZDOTDIR:-$HOME}/.zprezto"
git remote add upstream https://github.com/sorin-ionescu/prezto.git
cd ~
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N)
do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done

#update hosts
echo "127.0.0.1     activate.adobe.com" >> /etc/hosts
echo "127.0.0.1     practivate.adobe.com" >> /etc/hosts
echo "127.0.0.1     lm.licenses.adobe.com" >> /etc/hosts
echo "127.0.0.1     lmlicenses.wip4.adobe.com" >> /etc/hosts
echo "127.0.0.1     hlrcv.stage.adobe.com" >> /etc/hosts
echo "127.0.0.1     na1r.services.adobe.com" >> /etc/hosts

#DAW
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
  sudo installer -pkg "$serverdata/iZotope/etc/etc.mpkg" -target /
  sudo cp -pvr $serverdata/iZotope/etc/*.component $aupath/
  sudo cp -pvr $serverdata/iZotope/etc/*.vst $VSTpath/
  sudo cp -pvr $serverdata/iZotope/etc/*.vst3 $VST3path/
}

#PodFarm
install_podfarm() {
  dmg_file="$serverdata/Line6/PODFarm2.58.dmg"
  echo "$dmg_file"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/POD Farm 2.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
  sudo cp -rvp $serverdata/Line6/etc/L6TWXY.framework /Library/Frameworks
}

#LiquidSonics
install_LiquidSonics() {
  pkg_file="$serverdata/LiquidSonics/*.pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
  #open $serverdata/LiquidSonics/etc/License.lic
}

#Pianoteq
install_pianoteq() {
  pkg_file="$serverdata/Modartt/Install Pianoteq 5 STAGE.app"
  open "$pkg_file"
  echo "Please Manual Install:"
  read wait
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

  sudo cp -pvr $serverdata/overloud/etc/*.component $aupath/
  sudo cp -pvr $serverdata/overloud/etc/*.vst $VSTpath/
  sudo /usr/bin/ditto "$serverdata/overloud/etc/BREVERB 2.app" "/Applications/BREVERB 2.app"
}

#peavey
install_peavey() {
  pkg_file="$serverdata/peavey/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done
}

#PluginAlliance
install_PluginAlliance() {
  sudo cp -pvr $serverdata/PluginAlliance/AU/* $aupath/
  sudo cp -pvr $serverdata/PluginAlliance/VST/* $VSTpath/
  sudo cp -pvr $serverdata/PluginAlliance/VST3/* $VST3path/
  cp -pvr "$serverdata/PluginAlliance/Applications/Plugin Alliance" /Applications
}

#presonus
install_presonus() {
  dmg_file="$serverdata/presonus/PreSonus - Studio One 3 Professional v3.2.0.36707 OS X.dmg"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  sudo /usr/bin/ditto "$mount_dir/Studio One 3.app" "/Applications/Studio One 3.app"
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
    sudo cp -pvr "$pkg_file" $aupath/
    hdiutil detach "$mount_dir"
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

#steinberg cubase elements 8
install_cubase() {
  dmg_file="$serverdata/steinberg/Cubase_8_Elements/*.dmg"
  for dmg_files in $dmg_file
  do
    mount_dir=`hdiutil attach "$dmg_files" | awk -F '\t' 'END{print $NF}'`
    echo $mount_dir
    if [[ $mount_dir == '/Volumes/License' ]]; then
      echo "Manual Run Steinberg.command:Important!!!After Run SO match High CPU Usage!!!"
      #open $mount_dir/Steinberg.command
    else
      pkg_file="$mount_dir/Cubase LE AI Elements 8 for Mac OS X/Cubase LE AI Elements 8.pkg"
      sudo installer -pkg "$pkg_file" -target /
    fi

    hdiutil detach "$mount_dir"
  done
}

#ValhallaDSP
install_valhallaDSP() {
  sudo cp -pvr $serverdata/ValhallaDSP/*.component $aupath/
  sudo cp -pvr $serverdata/ValhallaDSP/*.vst $VSTpath/
  sudo rsync -avz "$serverdata/ValhallaDSP/Library/Audio/Presets/Valhalla DSP, LLC" /Library/Audio/Presets
}

#vocaloid
install_vocaloid() {
  #app installer
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
}

#vocaloid for cubase neo
install_vocaloidforcubase() {
  dmg_file="$serverdata/yamaha/Vocaloid for Cubase.cdr"
  mount_dir=`hdiutil attach "$dmg_file" | awk -F '\t' 'END{print $NF}'`
  pkg_file="$mount_dir/VOCALOID Editor for Cubase Installer.pkg"
  sudo installer -pkg "$pkg_file" -target /
  hdiutil detach "$mount_dir"
}

#waves
install_waves() {
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
}

#Spectrasonics
##trilian
install_trilian() {
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
}

##Omnisphere 2
install_omnisphere2() {
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
  sudo cp -pvr $serverdata/Spectrasonics/Omnisphere2/05_etc/Omnisphere_2.0.3d/*.component $aupath/
  sudo cp -pvr $serverdata/Spectrasonics/Omnisphere2/05_etc/Omnisphere_2.0.3d/*.vst $VSTpath/
}

#NativeInstrumens
install_NI() {
  nipath="$serverdata/NativeInstruments"
  #Preference Copy
  sudo rsync -av "$nipath/NI_Preference/"* '/Library/Preferences/'
  #rsync -av "$nipath/NI_Preference_users/"* '/Users/yutaro/Library/Preferences/'
  #mkdir
  sudo mkdir -p /Applications/Native\ Instruments/{Battery\ 4,Driver,Enhanced\ EQ,FM8,Guitar\ Rig\ 5,Kontakt\ 5,Massive,RC\ 24,Passive\ EQ,RC\ 48,Reaktor\ 6,Replika,Solid\ Bus\ Comp\ FX,Solid\ Dynamics\ FX,Solid\ EQ\ FX,Supercharger,Supercharger\ GT,Transient\ Master\ FX,VC\ 160\ FX,VC\ 2A\ FX,VC\ 76\ FX,Vari\ Comp}

  #for massive,Battery
  sudo mkdir /Applications/Native\ Instruments/Massive/Battery 4.app
  sudo mkdir /Applications/Native\ Instruments/Massive/Massive.app

  #pkg install
  rsync -av $nipath/pkgs/ $tmp
  pkg_file="$tmp/*pkg"
  for pkg_files in $pkg_file
  do
    rsync -av "$pkg_files"
    open "$pkg_files"
    echo 'Manual Install'
    read wait
  done

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

#    read wait

  #reaktor update
  pkg_file="$nipath/reaktor/update/*pkg"
  for pkg_files in $pkg_file
  do
    sudo installer -pkg "$pkg_files" -target /
  done

  rsync -avz "$nipath/Service Center" "/Users/yutaro/Library/Application Support/Native Instruments/Service Center"

  #etc plug-in
  sudo rsync -av $nipath/etc/AU/ $aupath/
  sudo rsync -av $nipath/etc//VST/ $VSTpath/

  #etc app
  sudo rsync -av "$nipath/etc/app/Battery 4.app" '/Applications/Native Instruments/Battery 4/'
  sudo rsync -av "$nipath/etc/app/FM8.app" '/Applications/Native Instruments/FM8/'
  sudo rsync -av "$nipath/etc/app/Guitar Rig 5.app" '/Applications/Native Instruments/Guitar Rig 5/'
  sudo rsync -av "$nipath/etc/app/Kontakt 5.app" '/Applications/Native Instruments/Kontakt 5/'
  sudo rsync -av "$nipath/etc/app/Massive.app" '/Applications/Native Instruments/Massive/'
  sudo rsync -av "$nipath/etc/app/Reaktor 6.app" '/Applications/Native Instruments/Reaktor 6/'
}

#install_logic
#install_bias
#install_bozdigital
#install_effectrix
#install_iZotope
#install_podfarm
#install_LiquidSonics
#install_pianoteq
#install_nugensudio
#install_overloud
#install_peavey
#install_PluginAlliance
#install_presonus
#install_psp
#install_redwirez
#install_samplemagic
#install_soundtoys
#install_cubase
#install_valhallaDSP
#install_vocaloid
#install_vocaloidforcubase
#install_waves
#install_trilian
#install_omnisphere2
#install_NI

#rm -d $tmp
