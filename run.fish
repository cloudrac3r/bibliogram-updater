#!/usr/bin/fish

source utils/helpers.fish

if do_update
	echo 'Self-update successful.'
	exec ./run.fish
end

if not test -e state/is_installed
	./install.fish
end

# ---

set pull_interval 10m
set update_applied false

cd bibliogram/src/site

do_update

while true
	set update_applied false

	echo '' | node server.js &
	set -l b_pid (jobs -p)

	while not $update_applied
		sleep $pull_interval

		if do_update
			set update_applied true
			kill $b_pid
		else
			echo '[ ] ['(date +%H%M%S)'] [UPD] No updates available yet.'
		end
	end
end
