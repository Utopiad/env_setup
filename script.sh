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

function install_brew_package() {
	printf "Checking installation of package %s via brew" $1
	brew ls --versions $1 > /dev/null;
	if [echo $? != 0]
	then
		printf "Package %s not installed. Proceding to installation..." $1
		brew install $1;
	else
		printf "Package %s is already installed, skipping" $1
	fi
}

if [ OsType == "Mac" ]	
	install_brew();
	install_brew_package "neovim"
	# Install Neovim "Paq" plugin manager
	echo "PAQ Installation"
	git clone --depth=1 https://github.com/savq/paq-nvim.git \ 
		"${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim;
	echo "nvim config initialization"
	if [ ! -d "~/.config" ]
	then
		echo "~/.config folder does not exist, creating it..."
		mkdir ~/.config;
	fi
	if [! -d "~/.config/nvim"]
	then
		echo "~/.config/nvim folder does not exist, creating it..."
		mkdir ~/.config/nvim;
	fi
	touch ~/.config/nvim/init.lua;

fi



