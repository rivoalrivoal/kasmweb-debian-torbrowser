FROM kasmweb/core-debian-bookworm:1.16.1

USER root

# Fix reverse proxy websocket
RUN sed -i "s|UI\.initSetting('path', 'websockify');|UI.initSetting('path', window.location.pathname.replace(/[^/]*$/, '').substring(1) + 'websockify');|" /usr/share/kasmvnc/www/dist/main.bundle.js

# VS Code
ADD https://raw.githubusercontent.com/kasmtech/workspaces-images/refs/heads/develop/src/ubuntu/install/vs_code/install_vs_code.sh /tmp/vscode/install_vs_code.sh
RUN mkdir -p /home/kasm-user/Desktop/ && \
    bash /tmp/vscode/install_vs_code.sh && rm -rf /tmp/vscode/

# Tor Browser
ADD https://raw.githubusercontent.com/kasmtech/workspaces-images/refs/heads/develop/src/ubuntu/install/torbrowser/install_torbrowser.sh /tmp/torbrowser/install_torbrowser.sh
RUN mkdir -p /home/kasm-user/Desktop/ && \
    bash /tmp/torbrowser/install_torbrowser.sh && rm -rf /tmp/torbrowser/
COPY ./tor-custom-prefs.js /tmp/tor-custom-prefs.js
RUN export TOR_TMP=/tmp/tor-browser-install && \
    cp -r $HOME/tor-browser $TOR_TMP && \
    chmod -R 777 $TOR_TMP && \
    sed -i 's/--detach/--detach --verbose/g' $TOR_TMP/tor-browser/start-tor-browser.desktop && \
    cat $TOR_TMP/tor-browser/Browser/TorBrowser/Data/Browser/profile.default/prefs.js /tmp/tor-custom-prefs.js > $TOR_TMP/tor-browser/Browser/TorBrowser/Data/Browser/profile.default/prefs.js

# Utils
RUN apt-get update && apt-get install -y nano nmap proxychains telnet

# Custom init script on startup
COPY ./custom_startup.sh /dockerstartup/custom_startup.sh
RUN chmod +x /dockerstartup/custom_startup.sh

# Clean this because created by root (?)
RUN rm -rf /home/kasm-user/.local && \
    rm -rf /home/kasm-user/.cache

USER 1000
