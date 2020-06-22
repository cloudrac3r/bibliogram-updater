#!/usr/bin/env fish

cd (dirname (status filename))

source utils/environment.fish; or exit
source utils/constants.fish; or exit
source utils/interactive.fish; or exit
source utils/helpers.fish; or exit

mkdir -p state

echo '
====================================
Welcome to the Bibliogram installer.
Please pay attention as you will be
asked to make choices.
====================================
'

require_command_deps wget git nc

if not command -sq node
	echo 'node not found in path.'
	echo 'Download the node executable now? It will not be installed system-wide.'
	echo "The Linux $arch version will be downloaded."
	continue_or_quit
	wget $node_download_url -O $node_tarball --progress=bar:noscroll -nv --show-progress; or exit
	echo -n 'Extracting... '
	tar -xaf $node_tarball; or exit
	echo 'done.'
	rm $node_tarball; or exit
	touch state/use_local_node
	echo
end

if test -e state/use_local_node
	set -a PATH $PWD/$node_folder/bin
end

if not test -e bibliogram
	git clone https://github.com/cloudrac3r/bibliogram; or exit
	mkdir -p bibliogram/db
else
	echo "Bibliogram is already cloned. We'll use the existing folder."
end
echo

pushd bibliogram

	# Assume no. This sounds like a good thing, but it's most likely not.
	set -a npm_install_args --no-optional
	set s_tor_enabled false
	# echo 'Use Tor for outgoing requests? (suggested: n)'
	# if not y_or_n
	# 	set -a npm_install_args --no-optional
	# 	set s_tor_enabled false
	# end
	# echo

	npm install $npm_install_args; or exit
	echo

popd

echo 'Create a new configuration file?'
echo 'If you have not created one yet, you MUST do this step now.'
echo 'If you have already created one, continuing will overwrite it.'
if y_or_n
	echo

	echo 'What URL will people visit to access your instance?'
	echo '(example for public internet: https://bibliogram.art)'
	set ip (ifconfig eth0 2>/dev/null | grep 'inet ' | awk '{print $2}')
	if test (count $ip) -eq 1
		echo "(example for your LAN: http://$ip:10407)"
	end
	set s_website_origin (get_input_matching 'https?://.+')
	echo

	echo "What port should Bibliogram's webserver listen on?"
	echo 'You cannot use ports below 1024.'
	set s_port (get_input_matching '\d+')
	echo

	echo 'Would you like to enable RSS/Atom feeds?'
	echo 'This will likely end up becoming a large part of your request volume,'
	echo 'which might the site unusable for visitors who just want to browse.'
	echo 'It will be inconvenient for users if you turn this off in the future.'
	echo 'Enable feeds?'
	if y_or_n
		set s_feeds_enabled true
	else
		set s_feeds_enabled false
	end
	echo

	echo "Does your server comply with EFF's Do Not Track policy?"
	echo 'Readable version of the policy: https://www.eff.org/pages/understanding-effs-do-not-track-policy-universal-opt-out-tracking'
	echo 'Full policy: https://www.eff.org/dnt-policy'
	echo 'Implementation guide: https://github.com/EFForg/dnt-guide'
	echo
	echo 'Saying yes will serve .well-known/dnt-policy.txt,'
	echo 'which makes some browser extensions unblock your site.'
	echo 'Enter "yes" if you do comply with the policy, or write anything else if not.'
	read -l dnt_response -P '[do you comply with this policy?] '
	set dnt_response (echo $dnt_response | tr '[:upper:]' '[:lower:]')
	if test "$dnt_response" = "yes"
		echo 'Thank you!'
		set s_does_not_track true
	else
		echo 'Noted.'
		set s_does_not_track false
	end
	echo

	write_config 'data/config.template' \
		s_website_origin,\" s_port s_does_not_track s_feeds_enabled \
		> bibliogram/config.js; or exit # the " is to surround the value to create a string
	echo 'Config file written.'
end
echo

touch state/is_installed

echo '  -> If you need help making Bibliogram accessible on the public internet, see:'
echo '     https://github.com/cloudrac3r/bibliogram/wiki/Installing#making-bibliogram-accessible-from-outside'
echo '  -> Please consider adding yourself to the instance list:'
echo '     https://github.com/cloudrac3r/bibliogram/wiki/Instances'
echo "  -> If you'd like to see the other configuration options, check out:"
echo '     https://github.com/cloudrac3r/bibliogram/wiki/Configuring'
echo '  -> Please take the time to write a privacy policy:'
echo '     https://github.com/cloudrac3r/bibliogram/blob/master/src/site/pug/privacy.pug.template'
echo
echo 'Start Bibliogram now?'

if y_or_n
	exec ./run.fish
end
