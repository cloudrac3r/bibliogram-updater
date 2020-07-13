#!/usr/bin/env fish

# See which commands are missing
missing=

# Test for fish
if ! which fish > /dev/null; then
	missing="$missing fish"
fi

# Test for git
if ! which git > /dev/null; then
	missing="$missing git"
fi

# Deal with missing commands
if test -n "$missing"; then
	if which apt > /dev/null; then
		# apt is available, use it to install both
		echo 'These commands are missing, but can probably be installed with apt:'
		echo "$missing"
		echo '`sudo apt` will be run now.'
		echo
		sudo apt update || exit
		sudo apt install -y $missing || exit
	else
		echo 'These commands are missing:'
		echo "$missing"
		echo 'Please install them to continue.'
		exit 1
	fi
fi

git clone https://git.sr.ht/~cadence/bibliogram-updater
cd bibliogram-updater
exec ./run.fish
