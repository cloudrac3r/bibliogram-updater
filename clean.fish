#!/usr/bin/fish

source utils/interactive.fish
source utils/constants.fish

echo 'Really clean?'
echo -n 'This will delete the directories `bibliogram`,'
if test -e $node_folder
	echo " `$node_folder`,"
else
	echo
end
echo 'and any files inside `state`.'
continue_or_quit

rm -rvf bibliogram | tail -n 1
rm -rvf $node_folder | tail -n 1
rm -vf state/*
