#!/usr/bin/env fish

cd (dirname (status filename))

source utils/helpers.fish; or exit
source utils/constants.fish; or exit

if test -e state/use_local_node
	set -a PATH $PWD/$node_folder/bin
end

set command $argv[1]

switch $command
	case checkout
		set -l branch $argv[2]

		if not test $branch
			echo 'You must supply the branch to checkout.' >&2
			exit 1
		end

		cd bibliogram; or exit
		git fetch; or exit
		if not set -l checkout_output (git checkout $branch 2>&1 >/dev/null)
		or set -l already_on (string match 'Already on *' -- $checkout_output)
			string sub $checkout_output >&2
			test $already_on
			exit
		end
		npm install

	case npm
		cd bibliogram; or exit
		npm $argv[2..-1]

	case \*
		echo 'Available commands: checkout, npm' >&2
		exit 1
end
