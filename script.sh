#!/usr/bin/env bash

echo "hello world!!"

OsType=""
if [ $(uname) == "Darwin" ]
then
	OsType="Mac"
else
	OsType=$(uname)	
fi

function install_brew() {
	which -s brew
	if [[ $? != 0 ]]
	then
		# Install Homebrew
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
	else
		brew update;
	fi
}

if [ OsType == "Mac" ]
	install_brew();
fi

function check_installation_of_brew_package() {
	printf "Checking installation of package $1 via brew"
	brew ls --versions $1 > /dev/null;
	if [echo $? != 0]
	then
		printf "Package $1 not installing. Proceding to installation..."
		brew install $1;
	else
		printf "Package $1 is already installed"
	fi
}

check_installation_of_brew_package "neovim"


