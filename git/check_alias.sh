#!/bin/bash
if ! (grep -q "alias sgit='~/stiffgit.sh'" ~/.bashrc || grep -q 'alias sgit="~/stiffgit.sh"' ~/.bashrc); then
	sudo echo "alias sgit='~/stiffgit.sh'" >> ~/.bashrc
	echo "Inserted alias for ~/stiffgit.sh"
	echo "Now you can use it as command 'sgit'"
else
	echo "'sgit' alias exisits, omitting"
fi

echo "Stiffgit script is now set up"
echo "Login to new shell to use it"
echo "Configure it with command 'sgit configure'"
