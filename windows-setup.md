# Install chocolatey

# Install Boxstarter
CINST Boxstarter

# poweshell setting change for ricty fonts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# WSL setting
appwiz.cpl
check 'Windows Subsystem for Linux'
install ubuntu from Windowsストア
sudo dpkg-reconfigure tzdata
sudo sed -i 's/\/archive\.ubuntu/\/jp\.archive\.ubuntu/' /etc/apt/sources.listCopy
sudo apt update
sudo apt upgrade -y
sudo apt install -y language-pack-ja
sudo update-locale LANG=ja_JP.UTF-8
sudo vim /etc/passwd
/mnt/c/Users/yutaro

# cmder setup
cp -f $HOME/Dropbox/Winkup/ConEmu.xml /mnt/c/tools/cmder/vendor/conemu-maximus5/ConEmu.xml

# NMM restore


# ENB MAN restore
## PILGRIM - Dread the Commonwealth
- Installation
Download the ENB 0.307 binaries from ENBDev.com and drop ONLY **d3d11.dll** and **d3dcompiler_46e.dll** into the root Fallout 4 folder with the exe files
Uninstall any weather mods or dark night mods you have active. Pilgrim is not compatible with them
Download the Pilgrim preset and drop the content into the root Fallout 4 folder
Download, install, and enable Pilgrim.esp

- Toggle-able Effects : Sharpening - Black Bars/Letterbox - Grain - Lens emulation and lift shadows
Open the ENB menu with the "end" key
Expand the "ENBEFFECTPOSTPASS.FX" from the right menu by clicking it
Untick the effects you don't want to use
Click "SAVE CONFIGURATION" from upper left corner to keep the changes
Close the menu with the "end" key

- Installation Notes
Except NAC (climate disabled), all weather mods are incompatible. Pilgrim has it's own custom weather plugin.
DLC Areas (Nuka World, Far Harbor) do not have Pilgrim custom weather yet. This is coming in a future update.
The "Darker Nights" mod is incompatible. Pilgrim already has dark nights anyway.
The mods to Dogmeat are optional
Pilgrim is compatible with any interior mod.
Uninstalling Pilgrim is completely safe and won't harm your game.

# non-chocolatey app
- [NMM](https://github.com/Nexus-Mods/Nexus-Mod-Manager/releases/download/0.65.9/Nexus.Mod.Manager-0.65.9.exe)
- [LOOT](https://github.com/loot/loot/releases/download/0.13.1/LOOT.Installer.exe)
- [SVP](http://www.svp-team.com/files/svp4-online.php?cfb3e677c20f09823c593391c3a9f710&83)
  - "9184a-6e951-fc2d2-0644f-9e997"
- [Vienna Ensemble Pro 6 ](http://eu.vsl.co.at/downloader.aspx?FileID=135491)
- [LOGICOOL OPTIONS](https://download01.logi.com/web/ftp/pub/techsupport/options/Options_6.92.275.exe)
