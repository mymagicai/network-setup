#!/bin/bash

# Check for arguments
if [ "$#" -ne 3 ]; then
    echo "Usage: $0 [Your_Wireless_Interface] [Your_Network_Name] [Your_Wifi_Password]"
    exit 1
fi

# Arguments from the command line
INTERFACE=$1
NETWORK_NAME=$2
WIFI_PASSWORD=$3

# File path
WPA_CONF="/etc/wpa_supplicant/wpa_supplicant.conf"

# Kill existing wpa_supplicant processes
sudo pkill -9 wpa_supplicant

# Remove existing control interface files
sudo rm -r /var/run/wpa_supplicant/*

# Create or update wpa_supplicant.conf file
if [ ! -f $WPA_CONF ]; then
    echo "Creating new wpa_supplicant.conf file..."
    echo "ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev" | sudo tee $WPA_CONF > /dev/null
    echo "update_config=1" | sudo tee -a $WPA_CONF > /dev/null
fi

echo "" | sudo tee -a $WPA_CONF > /dev/null
echo "network={" | sudo tee -a $WPA_CONF > /dev/null
echo "    ssid=\"$NETWORK_NAME\"" | sudo tee -a $WPA_CONF > /dev/null
echo "    psk=\"$WIFI_PASSWORD\"" | sudo tee -a $WPA_CONF > /dev/null
echo "}" | sudo tee -a $WPA_CONF > /dev/null

# Start a new wpa_supplicant process
sudo wpa_supplicant -i $INTERFACE -c $WPA_CONF -B

# Obtain an IP address
sudo dhclient $INTERFACE

