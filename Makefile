.DEFAULT_GOAL := help
.PHONY: all allinstall

# Basic packages
PACKAGES := base-devel curl git linux-headers ntfs-3g openssh ripgrep the_silver_searcher tmux tree unzip
# GUI
PACKAGES += pinta synaptics xclip xfce4
# Sound server
PACKAGES += pulseaudio pulseaudio-alsa
# Font
PACKAGES += noto-fonts noto-fonts-cjk noto-fonts-emoji
# Misc
PACKAGES += bat github-cli git-delta hyperfine ntfs-3g pinta trash-cli virtualbox wget


AUR_PACKAGES := google-chrome todotxt ttf-hackgen vlc-nox


GO_PACKAGES := github.com/rhysd/vim-startuptime@latest


# Default distribution is set to ArchLinux.
# You can specify a distribution as below:
# make task DST=YourDistribution
DST = arch

ifeq ($(DST), arch)
	INSTALL_PKG    = sudo pacman -S
	UPDATE_PKG     = sudo pacman -Syu
	REMOVE_PKG     = sudo pacman -R
	PACKAGES      += pacman-contrib
else ifeq ($(DST), ubuntu)
	INSTALL_PKG    = sudo apt-get -y install
	UPDATE_PKG     = sudo apt-get -y update
	ADD_REPOSITORY = sudo apt-add-repository ppa:
	REMOVE_PKG     = sudo apt-get -y remove
	PACKAGES      += todotxt-cli
else
	INSTALL_PKG    = sudo pacman -S
	UPDATE_PKG     = sudo pacman -Syu
	REMOVE_PKG     = sudo pacman -R
endif


PROJECT_PATH = $$HOME/ ## WIP
SKK_DIC_PATH = $$HOME/.skk
SRC_PATH     = $$HOME/src

LINKED_FILES = foo bar baz ## WIP

## help: Display this message.
help:
	@grep -P "^## [a-zA-Z_-]+: .[^\n]*$$" $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = "^## |: "}; {printf "\033[36m%-20s\033[0m %s\n", $$2, $$3}'

## all: Execute install and initialize.
all: install initialize

## backup: WIP Make backups of data.
backup:

## create_links: WIP Create links of data.
create_links:

## initialize: Initialize settings for some software.
initialize: init_git init_mirrorlist init_timezone

## install: Install everything needed except for i_virtualbox_ga.
install: install_go_packages \
	 i_deno i_docker i_fish i_fisher i_go i_nvm i_paru i_rbenv i_rust \
	 i_skk_dictionaries i_tpm i_vim

## install_optional: Install a tools for guest OSs on VirtualBox.
install_optional: i_virtualbox_ga

## init_git: Initialize settings for git.
init_git:
	git config --global user.email "104410688+NI57721@users.noreply.github.com"
	git config --global user.name "NI57721"
	git config --global core.pager cat
	git config --global init.defaultBranch main
	mkdir -p $$HOME/.ssh
	ssh-keygen -t rsa -f $$HOME/.ssh/ni57721
	echo -e " Host github github.com\n  HostName github.com\n  IdentityFile $$HOME/.ssh/ni57721\n  User git\n" | \
	  tee -a $$HOME/.ssh/config
	xdg-open https://github.com/settings/ssh

## init_mirrorlist: Sort the mirrorlist used by pacman.
init_mirrorlist:
	sudo cp /etc/pacman.d/mirrorlist{,.bak}
	sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.bak
	rankmirrors -n 0 /etc/pacman.d/mirrorlist.bak | sudo tee /etc/pacman.d/mirrorlist


## init_timezone: Initialize settings for timezones.
init_timezone:
	sudo timedatectl set-timezone Asia/Tokyo

## install_packages: Install packages.
install_packages:
	$(UPDATE_PKG)
	$(INSTALL_PKG) $(PACKAGES)

## install_go_packages: Install go packages.
install_go_packages:
	go install $(GO_PACKAGES)

## i_deno: Install deno.
i_deno:
	curl -fsSL https://deno.land/x/install/install.sh | bash

## i_docker: Install docker.
i_docker:
	$(REMOVE_PKG) docker docker-engine docker.io containerd runc
	$(UPDATE_PKG)
	$(INSTALL_PKG) \
	  ca-certificates \
	  gnupg \
	  lsb-release
	sudo mkdir -p /etc/apt/keyrings
	curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
	  sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
	echo "deb [arch="$$(dpkg --print-architecture)" \
	  signed-by=/etc/apt/keyrings/docker.gpg] \
	  https://download.docker.com/linux/ubuntu "$$(lsb_release -cs)" stable" | \
	  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
	$(UPDATE_PKG)
	$(INSTALL_PKG) docker-ce docker-ce-cli containerd.io docker-compose-plugin
	sudo groupadd docker
	sudo usermod -aG docker $$USER

## i_fish: Install fish shell.
i_fish:
	ifeq ($(DST), ubuntu)
		$(ADD_REPOSITORY)fish-shell/release-3
	endif
	$(UPDATE_PKG)
	$(INSTALL_PKG) fish

## i_fisher: Install fisher.
i_fisher: i_fish
	curl -sL https://git.io/fisher | source
	fish -c "fisher update"

## i_go: Install go.
i_go:
	# [[ -d $(SRC_PATH)/go ]] && rm -rf $(SRC_PATH)/go
	mkdir -p $(SRC_PATH)/go
	curl -L https:/go.dev/dl/$$(curl --silent https://go.dev/VERSION?m=text).linux-amd64.tar.gz \
	  > $(SRC_PATH)/hoge/latest_go.tar.gz
	tar -C $(SRC_PATH)/hoge -xzf $(SRC_PATH)/hoge/latest_go.tar.gz && rm $(SRC_PATH)/hoge/latest_go.tar.gz

## i_nvm: Install nvm.
i_nvm:
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

## i_paru: Install paru.
i_paru:
	git clone https://aur.archlinux.org/paru.git $(SRC_PATH)
	cd $(SRC_PATH)/paru && makepkg -si

## i_rbenv: Install rbenv.
i_rbenv:
	#git clone https://github.com/rbenv/rbenv.git $$HOME/.rbenv
	cd $$HOME/.rbenv && src/configure && make -C src
	#$$HOME/.rbenv/bin/rbenv init
	mkdir -p $$(rbenv root)/plugins
	git clone https://github.com/rbenv/ruby-build.git $$(rbenv root)/plugins/ruby-build
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

## i_rust: Install rust
i_rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash

## i_skk_dictionaries: Install dictionary files for skk.
i_skk_dictionaries:
	mkdir $(SKK_DIC_PATH)
	curl --remote-name-all --output-dir $(SKK_DIC_PATH) \
	  https://skk-dev.github.io/dict/SKK-JISYO.L.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.jinmei.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.geo.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.station.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.propernoun.gz \
	  https://skk-dev.github.io/dict/zipcode.tar.gz \
	  https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8
	find $(SKK_DIC_PATH) -name "*.gz" | xargs -I{} gzip -d {}
	tar -xf $(SKK_DIC_PATH)/zipcode.tar -C $(SKK_DIC_PATH) && rm $(SKK_DIC_PATH)/zipcode.tar

## i_tpm: Install tpm.
i_tpm:
	git clone https://github.com/tmux-plugins/tpm $$HOME/.tmux/plugins/tpm
	bash $$HOME/.tmux/plugins/tpm/bin/install_plugins

## i_vim: Build vim HEAD.
i_vim:
	$(UPDATE_PKG)
	# cproto libacl1-dev libgpm-dev libgtk-3-dev liblua5.2-dev
	# libluajit-5.1-2 libperl-dev libtinfo-dev libxmu-dev libxpm-dev lua5.2
	# python3-dev ruby-dev
	$(INSTALL_PKG) autoconf automake gettext luajit
	mkdir -p $(SRC_PATH)
	if [ ! -e $(SRC_PATH)/vim ]; then git clone https://github.com/vim/vim.git $(SRC_PATH)/vim; fi
	git -C $(SRC_PATH)/vim pull
	cd $(SRC_PATH)/vim/src && \
	  ./configure \
	    --with-features=huge --enable-gui=gtk3 --enable-perlinterp \
	    --enable-python3interp --enable-rubyinterp --enable-luainterp \
	    --with-luajit --enable-fail-if-missing
	cd $(SRC_PATH)/vim/src && make

## i_virtualbox_ga: Install VirtualBox Guest Additions.
i_virtualbox_ga:
	$(UPDATE_PKG)
	$(INSTALL_PKG) xserver-xorg xserver-xorg-core
	sudo mount /dev/cdrom /mnt
	sudo sh /mnt/VBoxLinuxAdditions.run

