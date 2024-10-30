#!/bin/sh
set -e

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a wifi password."
  exit 1
elif [ ! -f customization.json ]; then
  echo "Error: customization.json not found in the working directory."
  exit 1
fi
ssid=$(jq -r '.wifi_ssid // ""' customization.json)
if [ -z "$ssid" ]; then
  echo "Error: wifi_ssid not found in customization.json."
  exit 1
fi

mv "wlan/ssid_goes_here.psk" "wlan/$ssid.psk"
sed -i "s/passphrase_goes_here/$1/" "wlan/$ssid.psk"
