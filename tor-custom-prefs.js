user_pref("logging.config.clear_on_startup", false);
user_pref("logging.nsHttp", 3);
user_pref("logging.config.modules", "nsHttp:3");

user_pref("network.proxy.type", 1);
user_pref("network.proxy.socks", "__SOCKS_PROXY__");
user_pref("network.proxy.socks_port", 1080);
user_pref("network.proxy.socks_version", 5);
user_pref("network.proxy.socks_remote_dns", true);

user_pref("torbrowser.settings.proxy.enabled", true);
user_pref("torbrowser.settings.proxy.type", "socks5");
user_pref("torbrowser.settings.proxy.address", "__SOCKS_PROXY__");
user_pref("torbrowser.settings.proxy.port", 1080);
