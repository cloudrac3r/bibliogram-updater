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

# Update the URL for the git remote origin in the working directory.
# argv[1]: the previous URL. this must match, or it will not be changed.
# argv[2]: the new URL to change to.
# exit code: non-zero if problems
function update_origin_url
	set -l original_url_regex $argv[1]
	set -l new_url $argv[2]
	set -l current_url (git remote get-url origin)
	if string match --regex --entire $original_url_regex $current_url > /dev/null
		echo "Changing Git remote URL from $current_url to $new_url"
		git remote set-url origin $new_url; or return 1
		git fetch --quiet; or return 1
	end
end
