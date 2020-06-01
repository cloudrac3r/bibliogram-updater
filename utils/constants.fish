#!/usr/bin/fish

set node_download_url 'https://nodejs.org/dist/v12.16.3/node-v12.16.3-linux-x64.tar.xz'
set node_tarball 'node.tar.xz'
set node_folder 'node-v12.16.3-linux-x64'
set npm_install_args -s
set updater_host 'localhost'
set updater_port '10407'
set updater_endpoint '/api/update_stream'
set updater_useragent 'BibliogramUpdater/0.1'
set updater_protocol 'http'
set updater_fetcher $updater_protocol'_fetcher'

set http_fetcher nc $updater_host $updater_port
set https_fetcher openssl s_client -connect $updater_host:$updater_port \
	-servername $updater_host -quiet -ign_eof

set s_tor_enabled true

set s_website_origin
set s_port
set s_does_not_track
set s_feeds_enabled
