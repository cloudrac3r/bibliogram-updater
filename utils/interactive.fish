#!/usr/bin/fish

# Ask the user to press enter to continue or ctrl-c to quit.
function continue_or_quit
	read -P '[press Enter to continue, or Ctrl-C to quit] '
end

# Ask the user to type y or n.
# exit code: 0 if y, 1 if n.
function y_or_n
	while true
		read -l result -P '[press y or n] ' -n 1
		if test "$result" = 'y'
			return 0
		else if test "$result" = 'n'
			return 1
		end
	end
end

# Get user input matching some expression.
function get_input_matching
	set -l expression $argv[1]
	while true
		read -l result -P '[type!] > '
		if string match --regex --entire $expression $result
			return 0
		else
			echo "[input must match pattern: \"$expression\"]" >&2
		end
	end
end
