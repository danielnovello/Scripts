#!/usr/bin/env bash
# Script by Daniel

#########################
#Do you have permission?#
#########################
printf '%60s\n' | tr ' ' -
echo "Checking for correct permission"
printf '%60s\n' | tr ' ' -

# Ask for the administrator password upfront
echo "checking sudo state..."
if sudo grep -q "# %wheel\tALL=(ALL) NOPASSWD: ALL" "/etc/sudoers"; then
# Ask for the administrator password upfront
  echo "I need you to enter your sudo password so I can install some things:"
  sudo -v
# Keep-alive: update existing sudo time stamp until the script has finished
  while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
  read -r -p "Make sudo passwordless? [y|N] " response
  if [[ $response =~ (yes|y|Y) ]];then
      sed --version 2>&1 > /dev/null
      if [[ $? == 0 ]];then
          sudo sed -i 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      else
          sudo sed -i '' 's/^#\s*\(%wheel\s\+ALL=(ALL)\s\+NOPASSWD:\s\+ALL\)/\1/' /etc/sudoers
      fi
      sudo dscl . append /Groups/wheel GroupMembership $(whoami)
      echo "You can now run sudo commands without password!"
  fi
fi

#########################
#System Changes##########
#########################
printf '%60s\n' | tr ' ' -
echo "System Changes"
printf '%60s\n' | tr ' ' -

# Ask to make system changes
read -p "Would You Like to make system changes? (Finder, etc...) ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
sleep 1
# Keep-alive: update existing `sudo` time stamp until `MacScriptV1.sh` has finished
echo "Keep this mac alive while doing this task..."
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
sleep 1
# Set standby delay to 24 hours (default is 1 hour)
echo "Setting Standby Delay to 24 hours..."
sudo pmset -a standbydelay 86400
# Always show scrollbars
echo "Changing Finder Always show scrollbars..."
defaults write NSGlobalDomain AppleShowScrollBars -string "Always"
sleep 1
# Expand save panel by default
echo "Changing Finder Always expand save panel..."
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
sleep 1
# Expand print panel by default
echo "Changing Finder Always expand print panel..."
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
sleep 1
# Save to disk (not to iCloud) by default
echo "Changing Finder Always save to disk..."
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
sleep 1
# Disable the “Are you sure you want to open this application?” dialog
echo "Disabling Application confirmation dialog..."
defaults write com.apple.LaunchServices LSQuarantine -bool false
sleep 1
# Reveal IP address, hostname, OS version, etc. when clicking the clock in the login window
echo "Showing login window extra's (IP)..."
sudo defaults write /Library/Preferences/com.apple.loginwindow AdminHostInfo HostName
sleep 1
# Restart automatically if the computer freezes
echo "Turning on Restart if system freezes..."
sudo systemsetup -setrestartfreeze on
sleep 1
# Never go into computer sleep mode
sudo systemsetup -setcomputersleep Off > /dev/null
sleep 1
# Check for software updates daily, not just once per week
echo "Check for Apple updates once a day..."
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1
sleep 1
# Show icons for hard drives, servers, and removable media on the desktop
echo "Making Some Finder Changes..."
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool true
defaults write com.apple.finder ShowMountedServersOnDesktop -bool true
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool true
# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true
# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true
# Display full POSIX path as Finder window title
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# Enable AirDrop over Ethernet and on unsupported Macs running Lion
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true
sleep 1
# Enable the MacBook Air SuperDrive on any Mac
echo "Running Enable the MacBook Air SuperDrive on any Mac..."
sudo nvram boot-args="mbasd=1"
sleep 1
# Show Date on menubar
echo "Showing Date on menubar..."
defaults write com.apple.menuextra.clock.plist DateFormat "EEE dd MMM  h:mm:ss a"
killall "SystemUIServer";
sleep 1
# Disable reopen apps on login
echo "Disabling reopen apps on login..."
defaults write com.apple.loginwindow TALLogoutSavesState -bool false
sleep 1
# Show the ~/Library folder
echo "Showing the ~/Library folder..."
chflags nohidden ~/Library
sleep 1
# Expand the following File Info panes:
# “General”, “Open with”, and “Sharing & Permissions”
echo "Expand the following File Info panes: General, Open with, and Sharing & Permissions..." 
defaults write com.apple.finder FXInfoPanesExpanded -dict \
	General -bool true \
	OpenWith -bool true \
	Privileges -bool true

else
  echo "Done makng system changes"
fi

#########################
#App and utility Install#
#########################
printf '%60s\n' | tr ' ' -
echo "Application and utility Install"
printf '%60s\n' | tr ' ' -

# Ask to Install Applications and Utilities
read -p "Would You Like to Install Applications and Utilities ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then

read -p "Would You Like to Install Malwarebytes Anti-Malware ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing Malwarebytes Anti-Malware..."
       curl -O https://data-cdn.mbamupdates.com/web/mbam-mac-1.2.6.730.dmg
  echo "Removing old version of Malwarebytes Anti-Malware..."
       sudo rm -rf /Applications/Malwarebytes\ Anti-Malware.app
       hdiutil attach MBAM-Mac-1.1.3.72.dmg
       sudo cp -R /Volumes/Malwarebytes\ Anti-Malware/Malwarebytes\ Anti-Malware.app /Applications/
       hdiutil unmount /Volumes/Malwarebytes\ Anti-Malware/
       rm MBAM-Mac-1.1.3.72.dmg
       echo "Malwarebytes Anti-Malware Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Install VLC Player ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing VLC Player..."
     curl -L -o vlc.dmg "http://get.videolan.org/vlc/2.2.1/macosx/vlc-2.2.1.dmg"
  echo "Removing old version of VLC Player..."
     sudo rm -rf /Applications/VLC.app
     hdiutil mount -nobrowse vlc.dmg -mountpoint /Volumes/vlc
     sudo cp -R "/Volumes/vlc/VLC.app" /Applications
     hdiutil unmount "/Volumes/vlc"
     rm vlc.dmg
       echo "VLC Player Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to EtreCheck ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing EtreCheck..."
     curl -L -o EtreCheck.zip "https://etrecheck.com/download/EtreCheck.zip"
  echo "Removing old version of EtreCheck..."
     sudo rm -rf /Applications/EtreCheck.app
     unzip EtreCheck.zip
     sudo cp -R "EtreCheck.app" /Applications
     sudo rm -rf rm EtreCheck.zip
     sudo rm -rf rm EtreCheck.app
       echo "EtreCheck Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Java for OSX (Apple) ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Java for OSX..."
     curl -L -o javaforosx.dmg "http://support.apple.com/downloads/DL1572/en_US/javaforosx.dmg"
     hdiutil mount -nobrowse javaforosx.dmg -mountpoint /Volumes/javaforosx
     sudo installer -verbose -pkg /Volumes/javaforosx/JavaForOSX.pkg -target /
     hdiutil unmount "/Volumes/javaforosx"
     rm javaforosx.dmg
       echo "Java for OSX Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Flash for OSX ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing Flash for OSX..."
     sudo curl -O https://raw.githubusercontent.com/djquazzi/Scripts/master/AdobeFlashPlayer.pkg
     sudo installer -verbose -pkg AdobeFlashPlayer.pkg -target /
     sudo rm -rf AdobeFlashPlayer.pkg
       echo "Flash for OSX Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Install Skype ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Removing old version of Skype..."
  sudo rm -rf /Applications/Skype.app
  echo "Installing Skype..."
     curl -L -o skype.dmg "http://www.skype.com/go/getskype-macosx.dmg"
     hdiutil mount -nobrowse skype.dmg -mountpoint /Volumes/Skype
     cp -R "/Volumes/Skype/Skype.app" /Applications
     hdiutil unmount "/Volumes/Skype"
     rm skype.dmg
       echo "Skype Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Google Chrome ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing Google Chrome..."
     curl -L -o chrome.dmg "https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg"
  echo "Removing of version of Google Chrome..." 
     sudo rm -rf /Applications/Google\ Chrome.app
     hdiutil mount -nobrowse chrome.dmg -mountpoint /Volumes/chrome
     sudo cp -R "/Volumes/chrome/Google Chrome.app" /Applications
     hdiutil unmount "/Volumes/chrome"
     rm chrome.dmg
       echo "Google Chrome Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Install Firefox ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing Firefox..."
     curl -L -o firefox.dmg "http://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US"
  echo "Removing of version of Firefox..." 
     sudo rm -rf /Applications/Firefox.app   
     hdiutil mount -nobrowse firefox.dmg -mountpoint /Volumes/firefox
     sudo cp -R "/Volumes/firefox/Firefox.app" /Applications
     hdiutil unmount "/Volumes/firefox"
     rm firefox.dmg
       echo "Firefox Installed successfully";
else
  echo "Ok, next..."
fi
printf '%60s\n' | tr ' ' -
sleep 1
read -p "Would You Like to Install Google Drive ? (y/n)?" CONT
if [ "$CONT" == "y" ]; then
  echo "Installing Google Drive..."
     curl -L -o googledrive.dmg "https://dl-ssl.google.com/drive/installgoogledrive.dmg"
  echo "Removing of version of Google Drive..." 
     sudo rm -rf /Applications/Google Drive.app  
     hdiutil mount -nobrowse googledrive.dmg  -mountpoint /Volumes/googledrive
     sudo cp -R "/Volumes/googledrive/Google Drive.app" /Applications
     hdiutil unmount "/Volumes/googledrive"
     rm googledrive.dmg
     open /Applications/Google\ Drive.app 
       echo "Google Drive Installed successfully";
else
  echo "Ok, next..."
fi
sleep 1
else
  echo "Done Installing Applications and Utilities"
fi

#########################
#Mac Updates#############
#########################
printf '%60s\n' | tr ' ' -
echo "Mac Updates"
printf '%60s\n' | tr ' ' -

sleep 1
# Ask to Apple Updates
   read -p "Would You Like to run Apple Updates? (y/n)?" CONT
   if [ "$CONT" == "y" ]; then
# Remove All Caches
   sudo softwareupdate -i -a
    echo "Running Apple Updates (Restart is required)...";
else
  echo "Ok, next..."
fi

#########################
#Mac Maintenance#########
#########################
printf '%60s\n' | tr ' ' -
echo "Mac Maintenance"
printf '%60s\n' | tr ' ' -

sleep 1
# Ask to run Mainrenance
   read -p "Would You Like to run Maintenance? (y/n)?" CONT
   if [ "$CONT" == "y" ]; then
# Remove All Caches
   echo "Running Cache cleaner (Restart is required)..."
   rm -rf ~/Library/Caches/*
   rm -rf ~/Library/Saved\ Application\ State/*
   sudo rm -rf /Library/Caches/*
   sudo rm -rf /System/Library/Caches/*
# Turn Off Open windows after login
   defaults write com.apple.loginwindow TALLogoutSavesState 0
# Font Maintenance
   echo "Running Font Maintenance (Restart is required)...";
   atsutil databases -removeUser
   sudo atsutil databases -remove
   sudo atsutil server -shutdown
   sudo atsutil server -ping
   sudo rm -rf /var/folders/*
else
  echo "Done. Note that some of these changes require a logout/restart to take effect."
fi
sleep 1
#########################
#Repair Permissions?#########
#########################
printf '%60s\n' | tr ' ' -
echo "Repair Permissions"
printf '%60s\n' | tr ' ' -

# Ask to Repair Permissions
   read -p "Would You Like to Repair Permissions? (y/n)?" CONT
   if [ "$CONT" == "y" ]; then
# Repair Permissions
   echo "Repairing Permissions..."
   sudo /usr/libexec/repair_packages --repair --standard-pkgs --volume /
else
  echo "Ok, next..."
fi
sleep 1
#########################
#Restart?#########
#########################
printf '%60s\n' | tr ' ' -
echo "Complete. Please restart"
printf '%60s\n' | tr ' ' -

# Ask to Restart
   read -p "Would You Like to restart? (y/n)?" CONT
   if [ "$CONT" == "y" ]; then
# Restart
   echo "Restarting..."
   sudo shutdown -r now
else
printf '%60s\n' | tr ' ' -
printf '%60s\n' | tr ' ' -
printf '%60s\n' | tr ' ' -
printf '%60s\n' | tr ' ' -  
printf '%60s\n' | tr ' ' -
printf '%60s\n' | tr ' ' - 
  echo "Done. Note that some of these changes require a logout/restart to take effect."
fi


