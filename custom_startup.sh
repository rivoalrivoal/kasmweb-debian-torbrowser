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

# Replace __SOCKS_PROXY__ in the file
file="/usr/lib/firefox/defaults/pref/custom-prefs.js"

if [ -f "$file" ]; then
  sed -i "s/__SOCKS_PROXY__/$socks_proxy/g" "$file"
  echo "File updated: $file"
else
  echo "File not found: $file"
  exit 1
fi

echo $socks_proxy > $HOME/toto.txt

tail -f /dev/null