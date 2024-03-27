#!/bin/bash

GIT_REPO="your_account_name" #enter your git account name
GIT_MAIL="your_email" #enter mail for git
SSHKEYS_PATH=$(realpath "path_to_ssh_keys_folder(usually ~/.ssh/)") #enter path for ssh keys folder



help() {
	echo "Available commands:"
	echo "~/stiffgit.sh configure"
	echo "~/stiffgit.sh generate <key-name:string>"
	echo "~/stiffgit.sh add-key <key-path:string-path>"
	echo "~/stiffgit.sh clone <key-path:string-path> <project-name:string>"
	echo "~/stiffgit.sh push <key-path:string-path> <branch-name:string> <upstream:string or leave it blank>"
	echo "~/stiffgit.sh custom-command <key-path:string-path> <custom-cmd:string>"

}

add_key() {
	eval "$(ssh-agent -s)"
        ssh-add $1
        ssh -T git@github.com
}

if [[ "$1" == "configure" ]]; then
	echo "Configure your script for proper functionality"
	echo "Enter valid data into GIT_REPO, GIT_MAIL and SSHKEYS_PATH variables"
	script_path=$(readlink -f "$0")
	if command -v vim &> /dev/null; then
		vim +3 "$script_path"
		exit 1
	fi

	if command -v nano &> /dev/null; then
		nano "$script_path" +3
		exit 1
	fi

fi



if [[ "$1" == "help" ]]; then
	help
fi

if [[ "$1" == "generate" ]]; then
	if [[ -z "$2" ]]; then
		echo "no key name specified"
		exit 1
	fi

	ssh-keygen -t rsa -b 4096 -C "${GIT_MAIL}" -f ${SSHKEYS_PATH}/"$2"
fi

if [[ "$1" == "add-key" ]]; then

	if ! [[ -f "${2}" ]]; then
		echo "File does not exist"
		exit 1
	fi
	cat >> ~/.ssh/config <<EOF

Host *
        AddKeysToAgent yes
        IdentityFile ${2}
EOF
	add_key "$2"
fi

if [[ "$1" == "clone" ]]; then
	if [[ -z "$3" ]];then
	       echo "no project name specified"
	       exit 1
	fi

	add_key "$2"
	git clone git@github.com:${GIT_REPO}/"$3"
fi

if [[ "$1" == "push" ]]; then
        if [[ -z "$3" ]]; then
		echo "no branch name specified"
		exit 1
	fi

	add_key "$2"
	if [[ "$4" == "upstream" ]]; then
		git push -u origin "$3"
	fi
	if [[ "$4" != "upstream" ]]; then
		git push origin "$3"
	fi
fi

if [[ "$1" == "pull" ]]; then
        if [[ -z "$3" ]]; then
                echo "no branch name specified"
                exit 1
        fi

	add_key "$2"
	git pull origin "$3"
fi



if [[ "$1" == "custom-command" ]]; then
	if [[ -z "$3" ]]; then
		echo "No custom command specified"
		exit 1
	fi

	add_key "$2"
	custom_command="$3"
	$custom_command
fi
