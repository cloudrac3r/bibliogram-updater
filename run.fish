#!/usr/bin/env fish

cd (dirname (status filename))

source utils/helpers.fish; or exit
source utils/constants.fish; or exit

update_origin_url 'https://github.com/cloudrac3r/bibliogram-updater(?:.git)?' 'https://git.sr.ht/~cadence/bibliogram-updater'; or exit

if do_update
	echo 'Self-update successful.'
	exec ./run.fish
end

if not test -e state/is_installed
	exec ./install.fish
end

# ---

if test -e state/use_local_node
	set -a PATH $PWD/$node_folder/bin
end

set pull_interval 10m
set update_applied false
set should_auto_restart (count $argv[1] >/dev/null; and echo true; or echo false)
set auto_restart_cycles $argv[1]
set auto_restart_countdown $auto_restart_cycles

function do_restart_countdown
	$should_auto_restart; and test (quick_math auto_restart_countdown - 1) -le 0
end

cd bibliogram/src/site

update_origin_url 'https://github.com/cloudrac3r/bibliogram(?:.git)?' 'https://git.sr.ht/~cadence/bibliogram'; or exit

if do_update
	npm install --no-optional
end

while true
	set update_applied false

	echo '' | node server.js &

	while not $update_applied
		sleep $pull_interval

		if do_update; or do_restart_countdown
			npm install --no-optional
			set update_applied true
			set auto_restart_countdown $auto_restart_cycles
			kill (jobs -p)
		else
			echo '[ ] ['(date +%H%M%S)'] [UPD] No updates available yet.'
		end
	end
end
