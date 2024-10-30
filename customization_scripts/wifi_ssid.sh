#!/bin/sh
set -e

# Only run input validation, no actual configuration, because wifi is configured in wifi_password.sh

if [ -z "$1" ]; then
  echo "Error: No argument provided. Please provide a wifi SSID."
  exit 1
elif [ ! -f customization.json ]; then
  echo "Error: customization.json not found in the working directory."
  exit 1
fi
pw=$(jq -r '.wifi_password // ""' customization.json)
if [ -z "$pw" ]; then
  echo "Error: wifi_password not found in customization.json."
  exit 1
fi
