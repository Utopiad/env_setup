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
	which -s brewi >> /dev/null
	if [[ $? != 0 ]]
	then
		# Install Homebrew
		echo "Installing Homebrew as it's not installed yet"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
	else
		echo "Launching homebrew update..."
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
	# Needs to install nvm, npm and yarn before actually installing the plugins
	echo "Check if nvm is installed"
	nvm --version >> /dev/null;
	if [ $? != 0]
	then
		echo "nvm not installing, proceeding..."
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
		source ~/.zshrc;
	fi
	# Install and use node --lts version through nvm
	echo "Installing node lts version through nvm"
	nvm install --lts;
	npm --version >> /dev/null;
	if [ $? != 0]
	then
		echo "Insgalling yarn..."
		npm install --global yarn;
	fi

	install_brew;
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
	# Clones nvim config file repository from argument or mine from git@github.com:Utopiad/nvim_setup.git
	echo "Adding plugins to ~/.config/nvim/lua/plugins.lua"
	[[ $2 =~ (\.git)]] && git clone $2 ~/.config/nvim/ || git clone git@github.com:Utopiad/nvim_setup.git ~/.config.nvim/
	# Install plugins
	nvim --cmd PaqInstall ~/.config/nvim/lua/plugins.lua
	# (TODO) Setup Cocvim installing necessary front-end dependencies
fi



