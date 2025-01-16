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

# Tor Browser Config
rm -rf $HOME/tor-browser
mkdir -p $HOME/tor-browser
cp -r /tmp/tor-browser-install/* $HOME/tor-browser/
cp /tmp/tor-browser-install/tor-browser/start-tor-browser.desktop $HOME/Desktop/

# Replace __SOCKS_PROXY__ in the tor prefs file
file="$HOME/tor-browser/tor-browser/Browser/TorBrowser/Data/Browser/profile.default/prefs.js"

if [ -f "$file" ]; then
  sed -i "s/__SOCKS_PROXY__/$socks_proxy/g" "$file"
  echo "File updated: $file"
else
  echo "File not found: $file"
  exit 1
fi

while true; do
  sleep 3600
  echo "custom service sleeping..."
done
