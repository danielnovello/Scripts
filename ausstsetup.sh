#/bin/bash
echo ""
echo ""
printf '%60s\n' | tr ' ' -
echo "Please make sure you understand what this script does and how to execute it!"
echo "System Requirement is Mac OSX Server 10.8 and above"
printf '%60s\n' | tr ' ' -
echo ""
echo ""
echo "This is what's going to happen:"
echo "1. Autenticate as root. (Nothing destructive)"
echo "2. Select if running script for the first time, or skip and run the Adobe Update Tool."
echo "3. List some information about this machine."
echo "4. Download and copy all the relevant abobe tools to this machine"
echo "5. Create and Adobe VirtualHost website on port :1234"
echo "6. Fix Permissions"
echo "7. Restart We services"
echo "8. Select Adobe Update options (fresh, incremental or create client config file)"
echo ""
echo ""
sleep 3
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
#The Script##############
#########################
echo ""
  read -p "First time Setup? (Y or N) " -n 1 -r
  echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sleep 3
echo ""  
# Ask for MDM Server Name
   echo "Hostname of this server (FQDN) : "
   read input_variable
echo ""   
   echo "You entered: $input_variable"
printf '%60s\n' | tr ' ' -
echo "System Information"
printf '%60s\n' | tr ' ' -
echo "---Local Machine Hostname (This machine)---"
hostname
echo "---Local Machine IP Information (This machine)---"
ip=`ipconfig getifaddr en0` ; echo "$ip"
subnetmask=`ipconfig getoption en0 subnet_mask` ; echo "Subnet Mask $subnetmask"
gateway=`route -n get default | grep 'gateway' | awk '{print $2}'` ; echo "Gateway $gateway"
dns=`ipconfig getoption en0 domain_name_server` ; echo "DNS $dns"
echo "---MDM server Forward Lookup (A Record)---"
forward="address"
if host "$input_variable" | grep -q "$forward"; then
    host "$input_variable"
else
    echo "No Forward Record Found. Please resolve A record."
fi
echo "---MDM server Reverse Lookup (PTR Record)---"
ptr="pointer"
if host "$(dig +short "$input_variable")" | grep -q "$ptr"; then
    host "$(dig +short "$input_variable")"
else
    echo "No PTR Record Found. Please resolve reverse record."
fi
sleep 3
printf '%60s\n' | tr ' ' -
  echo "If No Forward Record Found. or No PTR Record Found. Please Fix and re-run"
  echo "If Forward and PTR Record OK. Continue..."
printf '%60s\n' | tr ' ' -
echo ""
  read -p "Would you like to Continue? (Y or N) " -n 1 -r
  echo    # (optional) move to a new line
if [[ $REPLY =~ ^[Yy]$ ]]
then
  sleep 3
  echo ""
  echo    "Downloading Adobe Update Server Setup Tool for Mac (v4)..."
  sleep 1  
    curl -O https://raw.githubusercontent.com/djquazzi/Scripts/master/AdobeUpdateServerSetupTool.zip
  echo    ""
  echo    "...Done"  
  printf '%60s\n' | tr ' ' -  
  sleep 3
  echo "Unzipping files..."
  unzip AdobeUpdateServerSetupTool.zip
  echo    ""
  echo    "...Done"
  printf '%60s\n' | tr ' ' -
  sleep 3
  echo "Removing old files..."
  rm AdobeUpdateServerSetupTool.zip
  echo    ""
  echo    "...Done"
  printf '%60s\n' | tr ' ' -
  sleep 3
  echo    "Setting Update Webserver and Making directories..."
  sudo mkdir /Library/Server/Web/Data/Sites/Adobe
  sudo mkdir /Library/Server/Web/Data/Sites/Adobe/tool
  sudo mkdir /Library/Server/Web/Data/Sites/Adobe/updates
  sudo mkdir /Library/Server/Web/Data/Sites/Adobe/updates/Adobe
  echo    ""
  echo    "...Done"
  printf '%60s\n' | tr ' ' -
  sleep 3
  echo "Copy files to websites directory"
  sudo cp AdobeUpdateServerSetupTool /Library/Server/Web/Data/Sites/Adobe/tool/
  sudo cp 0000_any_1234_adobe.conf /Library/Server/Web/Config/apache2/sites/
  sudo cp HDPIM.dylib /Library/Server/Web/Data/Sites/Adobe/tool/
  sudo cp HUM.dylib /Library/Server/Web/Data/Sites/Adobe/tool/
  sudo cp unar /Library/Server/Web/Data/Sites/Adobe/tool/
  echo    ""
  echo    "...Done"
  printf '%60s\n' | tr ' ' -
  sleep 3
  echo "Removing temporary files..."
  sudo rm  AdobeUpdateServerSetupTool
  sudo rm 0000_any_80_adobe.conf
  echo    ""
  echo    "...Done"
  printf '%60s\n' | tr ' ' -
  echo "Fixing permissions..."
  sleep 3
  sudo chmod u+x /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool
  sudo chmod -R 777 /Library/Server/Web/Data/Sites/Adobe
  echo    ""
  echo "...Done"
    sleep 3
fi
printf '%60s\n' | tr ' ' -
   echo "Restarting Webserver"
   sudo serveradmin stop web
   sleep 3
   sudo serveradmin start web
   sleep 3
   echo    ""
   echo    "...Done"
printf '%60s\n' | tr ' ' - 
printf '%60s\n' | tr ' ' - 
printf '%60s\n' | tr ' ' - 
fi
echo ""
echo "Adobe Update Server Options"
printf '%60s\n' | tr ' ' - 
select ausst in fresh_synchronization incremental_syncronization generate_client_configuration_xml
do
	case $ausst in
		fresh_synchronization)
			echo "sudo /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool --root=/Library/Server/Web/Data/Sites/Adobe/updates/Adobe/ --fresh"
			sudo /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool --root=/Library/Server/Web/Data/Sites/Adobe/updates/Adobe/ --fresh
			echo "--------------"
			;;
		incremental_syncronization)
			echo "sudo /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool --root=/Library/Server/Web/Data/Sites/Adobe/updates/Adobe/ --incremental" 
			sudo /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool --root=/Library/Server/Web/Data/Sites/Adobe/updates/Adobe/ --incremental
			echo "--------------"		
			;;
		generate_client_configuration_xml) 
		    echo "sudo /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool --root=/Library/Server/Web/Data/Sites/Adobe/updates/Adobe/ --genclientconf=/Library/Server/Web/Data/Sites/Adobe/updates/config/AdobeUpdaterClient --url=http://$ip:1234/Adobe/updates/Adobe"
		    sleep 3
		    printf '%60s\n' | tr ' ' - 
		    printf '%60s\n' | tr ' ' - 
		    printf '%60s\n' | tr ' ' - 
		    echo "The Override files will open in the finder!"
		    echo "Copy the files to the clients at /Library/Application Support/Adobe/AAMUpdater/1.0/AdobeUpdater.Overrides"
		    echo "Testing in the browser. If you error on line 1 at column 1: Document is empty. It is working!"
		    printf '%60s\n' | tr ' ' - 
		    printf '%60s\n' | tr ' ' - 
		    printf '%60s\n' | tr ' ' - 
		    printf '%60s\n' | tr ' ' - 
		    sleep 6
		    printf '%60s\n' | tr ' ' - 
		    sudo /Library/Server/Web/Data/Sites/Adobe/tool/AdobeUpdateServerSetupTool --root=/Library/Server/Web/Data/Sites/Adobe/updates/Adobe/ --genclientconf=/Library/Server/Web/Data/Sites/Adobe/updates/config/AdobeUpdaterClient --url=http://"$ip":1234/updates/Adobe/	
			open http://"$ip":1234/updates/Adobe/webfeed/oobe/aam20/mac/updaterfeed.xml
			open /Library/Server/Web/Data/Sites/Adobe/updates/config/AdobeUpdaterClient	
			echo "--------------"		    
			;;		
		*)		
			echo "Error: Please try again (select 1,2 or 3)!"
			;;
	esac
done
printf '%60s\n' | tr ' ' -
printf '%60s\n' | tr ' ' -  
