#!/usr/bin/env fish

# Write the value of variables into a file, using the names of the variables
# as the keys.
# argv[1]: the path to the template.
# argv[...]: the variable names.
# text: the new contents
function write_config
	set -l file_path $argv[1]
	set -l scripts
	for var in $argv[2..-1]
		set -l name (string split ',' $var)[1]
		set -l surround (string split ',' $var)[2]
		set -a scripts "s!\$$name!$surround$$name$surround!"
	end
	sed -e (string join ';' $scripts) $file_path
end

# Attempts to update.
# exit code: 0 if updated, 1 if no updates available
function do_update
	env LANG=C git pull | grep -v 'Already up[ -]to[ -]date.'
end
