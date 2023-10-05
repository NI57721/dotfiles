.DEFAULT_GOAL := help
.PHONY: all allinstall

# Basic packages
PACKAGES := base-devel curl fzf jq git linux-headers ntfs-3g openssh reflector
PACKAGES += ripgrep the_silver_searcher tmux tree unzip whois
# GUI and Desktop
PACKAGES += libreoffice-still pinta qt5-wayland sway swayidle swaylock thunar
PACKAGES += waybar wl-clipboard xorg-xwayland
# Sound
PACKAGES += pulseaudio pulseaudio-alsa pulseaudio-bluetooth bluez bluez-libs
PACKAGES += bluez-utils
# Font
PACKAGES += noto-fonts noto-fonts-cjk noto-fonts-emoji
# Misc
PACKAGES += alacritty bat dunst dust github-cli git-delta gnuplot grim hyperfine
PACKAGES += man-db man-pages neofetch ntfs-3g perl-image-exiftool pinta
PACKAGES += pptpclient putty python-qrcode traceroute trash-cli udisks2
PACKAGES += virtualbox wf-recorder wget wtype


AUR_PACKAGES := google-chrome grimshot sway-audio-idle-inhibit-git todotxt ttf-hackgen vlc-nox bluez-firmware


GO_PACKAGES := github.com/rhysd/vim-startuptime@latest github.com/yory8/clipman@latest
GO_PACKAGES := github.com/suin/git-remind@latest


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

## help: Display this message
help:
	@grep -P "^## [a-zA-Z_-]+: .[^\n]*$$" $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = "^## |: "}; {printf "\033[36m%-20s\033[0m %s\n", $$2, $$3}'

## all: Execute install and initialize
all: install initialize

## link: Create links from the files in dotfiles repository into $HOME
link:
	scripts/link.sh

## initialize: Initialize settings for some software
initialize: init_bash init_git init_grub init_mirrorlist \
	 init_pacman init_putty init_timezone

## install: Install everything needed except for i_virtualbox_ga
install: install_packages install_go_packages \
	 i_deno i_docker i_dropbox i_fish i_fisher i_go i_nvm i_paru i_rbenv \
	 i_rust i_skk_dictionaries i_tpm i_vim

## install_optional: Install a tools for guest OSs on VirtualBox
install_optional: i_virtualbox_ga

## init_bash: Add settings for umask and the path to User's bashrc
init_bash:
	if [ -f $$XDG_CONFIG_HOME/bash/bashrc ]; then \
	  echo -e "\
	\n\
	# Set umask for the whole system
	umask 077
	\n\
	# Read the bash config file in an XDG Base Directory\n\
	. $$XDG_CONFIG_HOME/bash/bashrc\n\
	" | \
	  sudo tee -a /etc/bash.bashrc > /dev/null; \
	fi

## init_git: Initialize settings for git
init_git:
	mkdir -p $$HOME/.ssh
	ssh-keygen -t rsa -f $$HOME/.ssh/ni57721
	echo -e "\
	Host github github.com\n\
	  HostName github.com\n\
	  IdentityFile $$HOME/.ssh/ni57721\n\
	  User git\n\
	" | \
	  tee -a $$HOME/.ssh/config
	xdg-open https://github.com/settings/ssh

## init_grub: Initialize settings for grub, where grub is hidden
init_grub:
	echo -e "\
	\n\
	# Hiding grub menu.\n\
	GRUB_FORCE_HIDDEN_MENU=true\
	" | \
	  sudo tee -a /etc/default/grub
	sudo grub-mkconfig -o /boot/grub/grub.cfg

## init_mirrorlist: Sort the mirrorlist used by pacman
init_mirrorlist:
	sudo cp /etc/pacman.d/mirrorlist{,.bak}
	sudo sed -i 's/^#Server/Server/' /etc/pacman.d/mirrorlist.bak
	rankmirrors -n 0 /etc/pacman.d/mirrorlist.bak | sudo tee /etc/pacman.d/mirrorlist

## init_pacman: Initialize settings for pacman, where Color and ILoveCandy are turned on
init_pacman:
	echo -e "\
	\n\
	Color\n\
	ILoveCandy\n\
	" | \
	  sudo tee -a /etc/pacman.conf

## init_putty: Make a directory putty for PuTTY to use this directory instead of $HOME/.putty
init_putty:
	mkdir $XDG_CONFIG_HOME/putty

## init_timezone: Initialize settings for timezones
init_timezone:
	sudo timedatectl set-timezone Asia/Tokyo

## install_packages: Install packages
install_packages:
	$(UPDATE_PKG)
	$(INSTALL_PKG) $(PACKAGES)

## install_aur: Install AURs
install_aur: # i_paru
	paru -S $(AUR_PACKAGES)

## install_go_packages: Install go packages
install_go_packages:
	for go_package in $(GO_PACKAGES); do \
	  go install $$go_package; \
	done;

## i_deno: Install deno
i_deno:
	curl -fsSL https://deno.land/x/install/install.sh | \
	  DENO_INSTALL=$$XDG_DATA_HOME/deno bash

## i_docker: Install docker
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

## i_dropbox: Install DropBox CLI tool
i_dropbox:
	curl -L https://www.dropbox.com/download?plat=lnx.x86_64 | \
	  tar -C $$HOME/hoge -xzf -

## i_fish: Install fish shell
i_fish:
	if [ "$(DST)" == ubuntu ]; then $(ADD_REPOSITORY)fish-shell/release-3; fi
	$(UPDATE_PKG)
	$(INSTALL_PKG) fish
	echo /bin/fish | sudo tee -a /etc/shells
	homectl update --shell=/bin/fish $$USER

## i_fisher: Install fisher
i_fisher: # i_fish
# curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
	curl -sL https://git.io/fisher | fish
	fish -c "fisher update"

## i_go: Install go
i_go:
	scripts/update_go.sh

## i_nvm: Install nvm
i_nvm:
	scripts/update_nvm.sh

## i_paru: Install paru
i_paru:
	mkdir -p $$XDG_DATA_HOME/paru
	if [ $$(git -C $$XDG_DATA_HOME/paru rev-parse --is-inside-work-tree 2>/dev/null) == true ]; then \
	  git -C $$XDG_DATA_HOME/paru pull; \
	else \
	  git clone https://aur.archlinux.org/paru.git $$XDG_DATA_HOME/paru; \
	fi
	cd $$XDG_DATA_HOME/paru && makepkg -si

## i_rbenv: Install rbenv
i_rbenv:
	git clone https://github.com/rbenv/rbenv.git $$RBENV_ROOT
	mkdir -p $$RBENV_ROOT/plugins
	git clone https://github.com/rbenv/ruby-build.git $$RBENV_ROOT/plugins/ruby-build
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

## i_rust: Install rust
i_rust:
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash

## i_skk_dictionaries: Install dictionary files for skk
i_skk_dictionaries:
	mkdir -p $$XDG_DATA_HOME/skk
	curl --remote-name-all --output-dir $$XDG_DATA_HOME/skk \
	  https://skk-dev.github.io/dict/SKK-JISYO.L.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.jinmei.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.geo.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.station.gz \
	  https://skk-dev.github.io/dict/SKK-JISYO.propernoun.gz \
	  https://skk-dev.github.io/dict/zipcode.tar.gz \
	  https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8
	find $$XDG_DATA_HOME/skk -name "*.gz" | xargs -I{} gzip -d {}
	tar -xf $$XDG_DATA_HOME/skk/zipcode.tar -C $$XDG_DATA_HOME/skk && \
	  rm $$XDG_DATA_HOME/skk/zipcode.tar

## i_tpm: Install tpm
i_tpm:
	git clone https://github.com/tmux-plugins/tpm $$XDG_CONFIG_HOME/tmux/plugins/tpm
	bash $$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins

## i_vim: Build vim HEAD
i_vim:
	$(UPDATE_PKG)
	# cproto libacl1-dev libgpm-dev libgtk-3-dev liblua5.2-dev
	# libluajit-5.1-2 libperl-dev libtinfo-dev libxmu-dev libxpm-dev lua5.2
	# python3-dev ruby-dev
	$(INSTALL_PKG) autoconf automake gettext luajit
	scripts/update_vim.sh

## i_virtualbox_ga: Install VirtualBox Guest Additions
i_virtualbox_ga:
	$(UPDATE_PKG)
	$(INSTALL_PKG) xserver-xorg xserver-xorg-core
	sudo mount /dev/cdrom /mnt
	sudo sh /mnt/VBoxLinuxAdditions.run

## i_vpn: Install VPN settings for Interlink
i_vpn_interlink: # pptpclient
	curl https://www.interlink.or.jp/support/vpn/myip/myiptools/myiptools.tar.gz > /tmp/myiptools.tar.gz
	sudo tar xvzf /tmp/myiptools.tar.gz -C /etc
	rm /tmp/myiptools.tar.gz
	echo -e "\
	MYIP_SERVER=\"myip*.interlink.or.jp\"\n\
	ID=\"mi*\"\n\
	PASSWORD=\"****\"\n\
	IPADDR=\"***.***.***.***\"\n\
	DNS1=\"203.141.128.35\"\n\
	DNS2=\"203.141.128.33\"\n\
	CLIENT_GLOBALIP=\"AUTO\"\n\
	" | \
	  sudo tee /etc/myip/myip.conf
	sudo vim -u NONE -N /etc/myip/myip.conf
	sudo /etc/myip/myip-setup
	sudo sed "2q; d" /etc/myip/myip.conf | sed "s/.*\"\(.*\)\"/\1/" | \
	  xargs -I{} sudo cat /etc/ppp/peers/myip_{}
	sudo cat /etc/ppp/chap-secrets

## create_arch_linux_installer: Create Arch Linux installer USB drive for booting in BIOS and UEFI systems.
create_arch_linux_installer:
	@echo -e "Check the name of a USB drive"
	# ls -l /dev/disk/by-id/usb-*
	@echo -e "\nEnsure that the USB drive is not mounted"
	lsblk
	@echo -e "\nDownload an ISO file"
	xdg-open https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/latest/
	@echo -e "\nExecute \"cp archlinux-YYYY.MM.DD-x86_64.iso /dev/your/USB/without/suffix\""

