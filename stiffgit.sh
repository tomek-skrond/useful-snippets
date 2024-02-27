#!/bin/bash

GIT_REPO="your_account_name"
GIT_MAIL="your_email"
SSHKEYS_PATH="path_to_ssh_keys_folder(usually ~/.ssh/)"

path=$1

help() {
	echo "Available commands:"
	echo "~/stiffgit.sh generate <key-name:string>"
	echo "~/stiffgit.sh add-key <key-path:string-path>"
	echo "~/stiffgit.sh clone <key-path:string-path> <project-name:string>"
	echo "~/stiffgit.sh push <key-path:string-path> <branch-name:string> <upstream:string or leave it blank>"

}

add_key() {
	eval "$(ssh-agent -s)"
        ssh-add $1
        ssh -T git@github.com
}

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
	cat >> ~/.ssh/config <<EOF

Host *
        AddKeysToAgent yes
        IdentityFile ${path}
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
