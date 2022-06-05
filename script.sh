#!/usr/bin/env bash

# Formats
Bold="\e[1m"
Underlined="\e[4m"
# Resets all attributes, NoColor
NC="\e[0m"

# Colors
Err="\e[91m"
Success="\e[92m"
Warning="\e[93m"
Info="\e[96m"


# Determining what OS is this program being run under
OsType=""
if [[ $(uname) == "Darwin" ]]
then
	OsType="Mac"
else
	OsType=$(uname)	
fi

printf "${Bold}Your os is ${OsType}${NC}\n"

function install_brew() {
	which -s brew >> /dev/null
	if [[ $? != 0 ]]
	then
		# Install Homebrew
		printf "${Bold}${Info}Installing Homebrew as it's not installed yet${NC}\n"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)";
	else
		printf "${Bold}Launching homebrew update...${NC}\n"
		brew update;
	fi
}

function install_brew_package() {
	printf "${Bold}${Info}Checking installation of package %s via brew${NC}\n" $1
	brew ls --versions $1 >> /dev/null;
	if [[ $? != 0 ]]
	then
		printf "Package %s not installed. Proceding to installation...\n" $1
		brew install $1;
	else
		printf "${Bold}${Warning}Package %s is already installed, skipping${NC}\n" $1
	fi
}

if [[ $OsType == "Mac" ]]
then
	# Needs to install nvm, npm and yarn before actually installing the plugins
	printf "${Bold}Check if nvm is installed${NC}\n"
	nvm --version >> /dev/null;
	if [[ $? != 0 ]]
	then
		printf "${Bold}${Info}nvm not installed, proceeding...${NC}\n"
		curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash;
		source ~/.zshrc;
	fi
	# Install and use node --lts version through nvm
	printf "${Bold}${Info}Installing node lts version through nvm${NC}\n"
	nvm install --lts;
	npm --version >> /dev/null;
	if [[ $? != 0 ]]
	then
		printf "${Bold}${Info}Installing yarn...${NC}\n"
		npm install --global yarn;
	fi

	install_brew;
	install_brew_package "neovim"
	# Install Neovim "Paq" plugin manager
	printf "${Bold}${Info}PAQ Installation${NC}\n"
	git clone --depth=1 https://github.com/savq/paq-nvim.git \ 
		"${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/pack/paqs/start/paq-nvim;
	printf "${Bold}${Info}nvim config initialization${NC}\n"
	if [[ ! -d "~/.config" ]]
	then
		printf "${Bold}${Info} ~/.config folder does not exist, creating it...${NC}\n"
		mkdir ~/.config;
	fi
	if [[ ! -d "~/.config/nvim" ]]
	then
		printf "${Bold}${Info} ~/.config/nvim folder does not exist, creating it...${NC}\n"
		mkdir ~/.config/nvim;
	fi
	# Clones nvim config file repository from argument or mine from git@github.com:Utopiad/nvim_setup.git
	printf "${Bold}${Info}Adding plugins to ~/.config/nvim/lua/plugins.lua${NC}\n"
	if [[ $2 =~ (\.git) ]]
	then
 		git clone $2 ~/.config/nvim/
	else 
		git clone git@github.com:Utopiad/nvim_setup.git ~/.config/nvim/
	fi
	# # Install plugins
	# nvim --cmd PaqInstall ~/.config/nvim/lua/plugins.lua;
	# (TODO) Setup Cocvim installing necessary front-end dependencies
else
	printf "${Bold}${Info}not MacOS${NC}\n"
fi



