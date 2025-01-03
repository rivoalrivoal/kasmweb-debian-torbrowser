#!/bin/bash

/usr/bin/desktop_ready

# Extract the domain
socks_proxy=$(echo "$https_proxy" | sed -n 's#^socks5://\([^:/]*\).*#\1#p')

# Check if the domain was extracted
if [ -z "$socks_proxy" ]; then
  echo "Failed to extract the SOCKS proxy domain."
  exit 1
fi

echo "Extracted SOCKS Proxy: $socks_proxy"

# Replace __SOCKS_PROXY__ in the firefox prefs file
file="/usr/lib/firefox/defaults/pref/custom-prefs.js"

if [ -f "$file" ]; then
  sed -i "s/__SOCKS_PROXY__/$socks_proxy/g" "$file"
  echo "File updated: $file"
else
  echo "File not found: $file"
  exit 1
fi

folder="$HOME/.config/BraveSoftware/Brave-Browser"

# Fix lock profile Brave
rm -f $folder/SingletonLock

brave-browser
sleep 30

# tail chrome debug : Brave logging
file="$folder/chrome_debug.log"
while true; do
  if [[ -f "$file" ]]; then
    tail -F "$file"
  else
    echo "File $file not found, waiting..."
    while [[ ! -f "$file" ]]; do
      sleep 1
    done
    echo "Fichier $file found, resuming monitoring..."
  fi
done
