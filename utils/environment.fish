#!/usr/bin/fish

# Check whether commands are available.
# argv: list of commands to check.
# output: commands that are not available.
function check_command_deps
	for command in $argv
		if not command -sq $command
			echo $command
		end
	end
end

# Ask the user to install some commands if they aren't available.
# argv: list of commands to check.
function require_command_deps
	set -l notfound (check_command_deps $argv)
	if test (count $notfound) -ne 0
		echo 'These commands are required by the script, but are not installed:'
		string join ', ' $notfound
		echo 'Please install them, then run the script again.'
		exit 1
	end
end
