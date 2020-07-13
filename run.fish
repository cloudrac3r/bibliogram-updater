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

cd bibliogram/src/site

update_origin_url 'https://github.com/cloudrac3r/bibliogram(?:.git)?' 'https://git.sr.ht/~cadence/bibliogram'; or exit

if do_update
	npm install --no-optional
end

while true
	set update_applied false

	echo '' | node server.js &
	set -l b_pid (jobs -p)

	while not $update_applied
		sleep $pull_interval

		if do_update
			npm install --no-optional
			set update_applied true
			kill $b_pid
		else
			echo '[ ] ['(date +%H%M%S)'] [UPD] No updates available yet.'
		end
	end
end
