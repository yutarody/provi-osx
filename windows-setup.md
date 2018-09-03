# Install Drivers
## For motherboard
[ASUS](https://www.asus.com/jp/Motherboards/TUF-H370-PRO-GAMING-WI-FI/HelpDesk_Download/)
- chipset
- LAN
- WIFI
- Audio
- Bluetooth

# Install chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Boxstarter
CINST Boxstarter

Install-BoxstarterPackage -PackageName "https://gist.githubusercontent.com/yutarody/0cb5401223691e771dc66921692587e2/raw/1fe60769648b048c2d0b9375fd176e07329917a2/Boxstarter.ps1" -DisableReboots

# poweshell setting change for ricty fonts
Set-ExecutionPolicy -ExecutionPolicy Unrestricted

# WSL setting
1. appwiz.cpl
    check 'Windows Subsystem for Linux'
2. install ubuntu from Windowsストア
3. sudo dpkg-reconfigure tzdata
4. aptのレポジトリ変更 >> dropbox/winkup
  - /etc/apt/sources.list.d/iij.list
  - /etc/apt/sources.list.d/jaist.list
  - /etc/apt/sources.list << コメントアウトする
  - [参考](https://mstn.hateblo.jp/entry/2017/09/21/211733)
5. sudo apt update
6. sudo apt upgrade -y
7. sudo apt install -y language-pack-ja
8. sudo update-locale LANG=ja_JP.UTF-8

# cmder setup
cp -f $HOME/Dropbox/Winkup/ConEmu.xml /mnt/c/tools/cmder/vendor/conemu-maximus5/ConEmu.xml

# NMM restore


# ENB MAN restore
## PILGRIM - Dread the Commonwealth

# non-chocolatey app
- [NMM](https://github.com/Nexus-Mods/Nexus-Mod-Manager/releases/download/0.65.9/Nexus.Mod.Manager-0.65.9.exe)
- [LOOT](https://github.com/loot/loot/releases/download/0.13.1/LOOT.Installer.exe)
- [SVP](http://www.svp-team.com/files/svp4-online.php?cfb3e677c20f09823c593391c3a9f710&83)
- [Vienna Ensemble Pro 6 ](http://eu.vsl.co.at/downloader.aspx?FileID=135491)
- [LOGICOOL OPTIONS](https://download01.logi.com/web/ftp/pub/techsupport/options/Options_6.92.275.exe)

# other setting
- autologin
  1. netplwiz
  2. check
      >ユーザーがこのコンピューターを使うには、ユーザー名とパスワードの入力が必要'

-
