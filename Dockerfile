FROM kasmweb/core-debian-bookworm:1.16.1

USER root

# Fix reverse proxy websocket
RUN sed -i "s|UI\.initSetting('path', 'websockify');|UI.initSetting('path', window.location.pathname.replace(/[^/]*$/, '').substring(1) + 'websockify');|" /usr/share/kasmvnc/www/dist/main.bundle.js

# Tor Browser
RUN echo "deb http://deb.debian.org/debian/ bookworm main contrib non-free" > /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y torbrowser-launcher

# Google Chrome
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add - && \
    echo "deb http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y google-chrome-stable

# Firefox
RUN wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null && \
    echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" > /etc/apt/sources.list
RUN apt-get update && \
    apt-get install -y firefox

# Clean this because created by root (?)
RUN rm -rf /home/kasm-user/.local && \
    rm -rf /home/kasm-user/.cache

USER 1000
