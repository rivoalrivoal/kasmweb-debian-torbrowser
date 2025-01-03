FROM kasmweb/core-debian-bookworm:1.16.1

USER root

# Fix reverse proxy websocket
RUN sed -i "s|UI\.initSetting('path', 'websockify');|UI.initSetting('path', window.location.pathname.replace(/[^/]*$/, '').substring(1) + 'websockify');|" /usr/share/kasmvnc/www/dist/main.bundle.js

# Brave
ADD https://raw.githubusercontent.com/kasmtech/workspaces-images/refs/heads/develop/src/ubuntu/install/brave/install_brave.sh /tmp/brave/install_brave.sh
RUN mkdir /home/kasm-user/Desktop/ && \
    bash /tmp/brave/install_brave.sh && rm -rf /tmp/brave/
COPY ./brave-policy.json /etc/brave/policies/managed/disable_tor.json
RUN sed -i 's/--password-store=basic/& --proxy-server="${HTTPS_PROXY}"/g' /usr/bin/brave-browser

# Tor Browser
RUN echo "deb http://deb.debian.org/debian/ bookworm main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y torbrowser-launcher

# Firefox
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y firefox
COPY ./firefox-custom-prefs.js /usr/lib/firefox/defaults/pref/custom-prefs.js
# Because container run as user
RUN chmod 777 -R /usr/lib/firefox/defaults/pref/

# Custom init script on startup
COPY ./custom_startup.sh /dockerstartup/custom_startup.sh
RUN chmod +x /dockerstartup/custom_startup.sh

# Clean this because created by root (?)
RUN rm -rf /home/kasm-user/.local && \
    rm -rf /home/kasm-user/.cache

USER 1000
