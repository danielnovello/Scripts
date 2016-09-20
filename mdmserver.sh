#/bin/bash
# Ask for MDM Server Name
   echo "Hostname of your MDM server (FQDN) : "
   read input_variable
   echo "You entered: $input_variable"
printf '%60s\n' | tr ' ' -
echo "System Information"
printf '%60s\n' | tr ' ' -
echo "---Local Machine Hostname (This machine)---"
hostname
echo "---Local Machine IP Information (This machine)---"
ip=`ipconfig getifaddr en0` ; echo "Ip Address $ip"
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
printf '%60s\n' | tr ' ' -
printf '%60s\n' | tr ' ' -
echo "---Scannnned "$input_variable"---"
string="Open"
if /System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources/stroke "$input_variable" 80 80 | grep -q "$string"; then
    echo "Port 80 is OPEN (Provides access to the web interface for Profile Manager admin. Outbound from your MDM to Apple and your client device, outbound/inbound on your client device to your MDM)"
else
    echo "Port 80 is CLOSED (Provides access to the web interface for Profile Manager admin. Outbound from your MDM to Apple and your client device, outbound/inbound on your client device to your MDM)"
fi
string="Open"
if /System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources/stroke "$input_variable" 443 443 | grep -q "$string"; then
    echo "Port 443 is OPEN (Provides access to the web interface for Profile Manager admin. Outbound from your MDM to Apple and your client device, outbound/inbound on your client device to your MDM)"
else
    echo "Port 443 is CLOSED (Provides access to the web interface for Profile Manager admin. Outbound from your MDM to Apple and your client device, outbound/inbound on your client device to your MDM)"
fi
string="Open"
if /System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources/stroke "$input_variable" 1640 1640 | grep -q "$string"; then
    echo "Port 1640 is OPEN (Enrollment access to the Certificate Authority)"
else
    echo "Port 1640 is CLOSED (Enrollment access to the Certificate Authority)"
fi
printf '%60s\n' | tr ' ' -
echo "---Scanning for Apple Push Notification Service---"
string="Open"
if /System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources/stroke gateway.push.apple.com 2195 2195 | grep -q "$string"; then
    echo "Port 2195 is OPEN (Used by Profile Manager to send push notifications. Outbound from your MDM to Apple Servers)"
else
    echo "Port 2195 is CLOSED (Used by Profile Manager to send push notifications Outbound from your MDM to Apple Servers)"
fi
string="Open"
if /System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources/stroke gateway.push.apple.com 2196 2196 | grep -q "$string"; then
    echo "Port 2196 is OPEN (Used by Profile Manager to send push notifications. Outbound from your MDM to Apple Servers)"
else
    echo "Port 2196 is CLOSED (Used by Profile Manager to send push notifications. Outbound from your MDM to Apple Servers)"
fi
if /System/Library/CoreServices/Applications/Network\ Utility.app/Contents/Resources/stroke gateway.push.apple.com 5223 5223 | grep -q "$string"; then
    echo "Port 5223 is OPEN (Used to maintain a persistent connection to APNs and receive push notifications. Outbound from your MDM to Apple and outbound/inbound from your CLIENT device to Apple)"
else
    echo "Port 5223 is CLOSED (Used to maintain a persistent connection to APNs and receive push notifications. Outbound from your MDM to Apple and outbound/inbound from your CLIENT device to Apple)"
fi
printf '%60s\n' | tr ' ' -

