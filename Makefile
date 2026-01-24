.DEFAULT_GOAL := help

include data/*.mk

# The default distribution is Arch Linux.
# To override it:
# 	make <target> DST=<distribution>
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

## help: Show this message
.PHONY: help
help:
	@grep --no-filename --perl-regexp "^## [a-zA-Z_-]+: .[^\n]*$$" $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = "^## |: "}; {printf "\033[36m%-20s\033[0m %s\n", $$2, $$3}'

## all: Run install and initialize
.PHONY: all
all: install initialize

## basic: Run a minimal install and initialization
.PHONY: basic
basic: install_basic initialize_basic

## link: Create symlinks from this repo into $HOME
.PHONY: link
link:
	scripts/link.sh

## initialize: Initialize settings for installed software
.PHONY: initialize
initialize: initialize_basic \
	init_curl \
	init_docker \
	init_grub \
	init_mirrorlist \
	init_pacman

## initialize_basic: Initialize a minimal set of settings
.PHONY: initialize_basic
initialize_basic: \
	init_bash \
	init_git \
	init_putty \
	init_timezone

## install: Install everything
.PHONY: install
install: install_basic \
	i_dropbox \
	i_go \
	i_nvm \
	i_rbenv \
	i_rust \
	i_vpn \
	install_packages \
	install_aur_packages \
	install_go_packages

## install_basic: Run a minimal install
.PHONY: install_basic
install_basic: \
	i_paru \
	install_basic_packages \
	i_deno \
	i_fish \
	i_fisher \
	i_skk_dictionaries \
	i_tpm \
	i_vim \

## init_bash: Set umask and source the user's bashrc
.PHONY: init_bash
init_bash:
	cat config.d/bash.bashrc/defaults.sh | sudo tee --append /etc/bash.bashrc

## init_curl: Set up cURL
.PHONY: init_curl
init_curl:
	mkdir --parents $$XDG_CONFIG_HOME/curl
	cat .config/curlrc.template | envsubst > $$XDG_CONFIG_HOME/curlrc

## init_docker: Set up Docker
.PHONY: init_docker
init_docker:
	sudo systemctl enable docker.service
	sudo systemctl restart docker.service
	sudo groupadd docker || :
	sudo gpasswd -a $$USER docker

## init_git: Initialize settings for Git
.PHONY: init_git
init_git:
	mkdir -p $$HOME/.ssh
	ssh-keygen -t rsa -f $$HOME/.ssh/ni57721
	cat config.d/ssh/github.conf >> $$HOME/.ssh/config
	xdg-open https://github.com/settings/ssh

## init_grub: Hide the grub menu
.PHONY: init_grub
init_grub:
	sudo install -m 0644 config.d/grub/defaults.sh /etc/default/grub
	sudo grub-mkconfig -o /boot/grub/grub.cfg

## init_mirrorlist: Sort pacman's mirrorlist
.PHONY: init_mirrorlist
init_mirrorlist:
	sudo cp /etc/pacman.d/mirrorlist{,.bak}
	sudo sed --in-place /etc/pacman.d/mirrorlist.bak \
		--regexp-extended --expression 's/^[[:space:]]*#[[:space:]]*(Server)[[:space:]]*/\1 /'
	rankmirrors -n 0 /etc/pacman.d/mirrorlist.bak | sudo tee /etc/pacman.d/mirrorlist

## init_pacman: Enable some pacman options
.PHONY: init_pacman
init_pacman:
	sudo sed --in-place /etc/pacman.conf \
		--regexp-extended --expression \
		's/^[[:space:]]*#[[:space:]]*(Color)[[:space:]]*$$/\1\nILoveCandy/' \
		--regexp-extended --expression \
		's/^[[:space:]]*#[[:space:]]*(VerbosePkgLists)[[:space:]]*$$/\1/' \
		--regexp-extended --expression \
		's/^[[:space:]]*#[[:space:]]*(ParallelDownloads)[[:space:]]*=.*/\1 = 5/'

## init_putty: Create an XDG config directory for PuTTY
.PHONY: init_putty
init_putty:
	mkdir $$XDG_CONFIG_HOME/putty

## init_timezone: Initialize settings for timezones
.PHONY: init_timezone
init_timezone:
	sudo timedatectl set-timezone Asia/Tokyo

## install_basic_packages: Install basic packages
.PHONY: install_basic_packages
install_basic_packages:
	$(UPDATE_PKG)
	$(INSTALL_PKG) $(BASIC_PACKAGES) $(BASIC_AUR_PACKAGES)

## install_packages: Install packages
.PHONY: install_packages
install_packages: install_basic_packages
	$(UPDATE_PKG)
	$(INSTALL_PKG) $(PACKAGES)

## install_aur_packages: Install AUR packages
.PHONY: install_aur_packages
install_aur_packages: i_paru
	paru -S $(AUR_PACKAGES)

## install_go_packages: Install go packages
.PHONY: install_go_packages
install_go_packages:
	for go_package in $(GO_PACKAGES); do \
		go install $$go_package; \
	done;

## i_deno: Install deno
.PHONY: i_deno
i_deno:
	scripts/peeping.sh "https://deno.land/x/install/install.sh" | \
		DENO_INSTALL=$$XDG_DATA_HOME/deno sh

## i_dropbox: Install Dropbox CLI tool
.PHONY: i_dropbox
i_dropbox:
	curl -L https://www.dropbox.com/download\?plat=lnx.x86_64 | \
		tar -xzf -

## i_fish: Install fish shell
.PHONY: i_fish
i_fish:
	if [ "$(DST)" = ubuntu ]; then \
		$(ADD_REPOSITORY)fish-shell/release-3; \
	fi
	$(UPDATE_PKG)
	$(INSTALL_PKG) fish
	echo /bin/fish | sudo tee --append /etc/shells
	homectl update --shell=/bin/fish $$USER

## i_fisher: Install fisher
.PHONY: i_fisher
i_fisher: # i_fish
	scripts/peeping.sh \
		"https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish" | \
		fish && \
		fish -c "fisher install jorgebucaran/fisher"

## i_go: Install go
.PHONY: i_go
i_go:
	scripts/update_go.sh

## i_nvm: Install nvm
.PHONY: i_nvm
i_nvm:
	scripts/update_nvm.sh

## i_paru: Install paru
.PHONY: i_paru
i_paru:
	mkdir -p $$XDG_DATA_HOME/paru
	cd $$XDG_DATA_HOME/paru; \
	if [ "$$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then \
		git pull; \
	else \
		git clone https://aur.archlinux.org/paru.git $$XDG_DATA_HOME/paru; \
	fi
	cd $$XDG_DATA_HOME/paru && makepkg -si

## i_rbenv: Install rbenv
.PHONY: i_rbenv
i_rbenv:
	sudo pacman -Rsc ruby
	git clone https://github.com/rbenv/rbenv.git $$RBENV_ROOT
	mkdir -p $$RBENV_ROOT/plugins
	git clone https://github.com/rbenv/ruby-build.git $$RBENV_ROOT/plugins/ruby-build
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash

## i_rust: Install rust
.PHONY: i_rust
i_rust:
	scripts/peeping.sh "https://sh.rustup.rs" | bash

## i_skk_dictionaries: Install dictionary files for skk
.PHONY: i_skk_dictionaries
i_skk_dictionaries:
	mkdir -p $$XDG_DATA_HOME/skk
	curl --remote-name-all --output-dir $$XDG_DATA_HOME/skk \
		https://skk-dev.github.io/dict/SKK-JISYO.L.gz \
		https://skk-dev.github.io/dict/SKK-JISYO.jinmei.gz \
		https://skk-dev.github.io/dict/SKK-JISYO.geo.gz \
		https://skk-dev.github.io/dict/SKK-JISYO.station.gz \
		https://skk-dev.github.io/dict/SKK-JISYO.propernoun.gz \
		https://skk-dev.github.io/dict/zipcode.tar.gz \
		https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8 \
		https://skk-dev.github.io/dict/SKK-JISYO.edict.tar.gz
	find $$XDG_DATA_HOME/skk -name "*.gz" | xargs -I{} gzip -d {}
	tar -xf $$XDG_DATA_HOME/skk/zipcode.tar -C $$XDG_DATA_HOME/skk && \
		rm $$XDG_DATA_HOME/skk/zipcode.tar
	tar -xf $$XDG_DATA_HOME/skk/SKK-JISYO.edict.tar -C $$XDG_DATA_HOME/skk && \
		rm $$XDG_DATA_HOME/skk/SKK-JISYO.edict.tar
	git clone https://github.com/tokuhirom/jawiki-kana-kanji-dict \
		$$XDG_DATA_HOME/skk/jawiki-kana-kanji-dict

## i_tpm: Install tpm
.PHONY: i_tpm
i_tpm:
	git clone https://github.com/tmux-plugins/tpm $$XDG_CONFIG_HOME/tmux/plugins/tpm
	bash $$XDG_CONFIG_HOME/tmux/plugins/tpm/bin/install_plugins

## i_vim: Build vim HEAD
.PHONY: i_vim
i_vim:
	$(UPDATE_PKG)
	$(INSTALL_PKG) autoconf automake gettext luajit
	scripts/update_vim.sh

## i_vpn: Install VPN settings
.PHONY: i_vpn
i_vpn:
	sudo mv /etc/swanctl/swanctl.conf{,.bak}
	echo -e "\
	connections {\n\
	    vpn {\n\
	        version = 2\n\
	        proposals = aes192gcm16-aes128gcm16-prfsha256-ecp256-ecp521,aes192-sha256-modp3072,default\n\
	        rekey_time = 0s\n\
	        fragmentation = yes\n\
	        dpd_delay = 300s\n\
	        local_addrs = %defaultroute\n\
	        remote_addrs = <Your VPN Server URL>\n\
	        vips=0.0.0.0,::\n\
	        local {\n\
	            auth = eap-mschapv2\n\
	            eap_id = \"<Your ID>\"\n\
	        }\n\
	        remote {\n\
	            auth = pubkey\n\
	            id = %any\n\
	        }\n\
	        children {\n\
	            vpn {\n\
	                remote_ts = 0.0.0.0/0,::/0\n\
	                rekey_time = 0s\n\
	                dpd_action = clear\n\
	                esp_proposals = aes192gcm16-aes128gcm16-prfsha256-ecp256-modp3072,aes192-sha256-ecp256-modp3072,default\n\
	            }\n\
	        }\n\
	    }\n\
	}\n\
	\n\
	secrets {\n\
	    eap-vpn {\n\
	        id = \"<Your ID>\"\n\
	        secret = \"<Your Password>\"\n\
	    }\n\
	}\n\
	" | \
		sudo tee /etc/swanctl/swanctl.conf
	sudo rvim /etc/swanctl/swanctl.conf
	sudo rmdir /etc/ipsec.d/cacerts
	sudo ln -s /etc/ssl/certs /etc/ipsec.d/cacerts

## i_vpn_with_ppp: Install VPN settings with ppp
.PHONY: i_vpn_with_ppp
i_vpn_with_ppp:
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

## create_arch_linux_installer: Create an Arch Linux installer USB (BIOS/UEFI)
.PHONY: create_arch_linux_installer
create_arch_linux_installer:
	@echo -e "Download the ISO if needed"
	mkdir -p $$XDG_CACHE_HOME/arch-installation
	curl https://archlinux.org/iso/latest/archlinux-x86_64.iso.sig \
		> $$XDG_CACHE_HOME/arch-installation/archlinux.sig.tmp
	if [ ! -f $$XDG_CACHE_HOME/arch-installation/archlinux.sig ] || \
		[ -n "$$(cmp $$XDG_CACHE_HOME/arch-installation/archlinux.sig{,.tmp})" ]; then \
		curl https://ftp.jaist.ac.jp/pub/Linux/ArchLinux/iso/latest/archlinux-x86_64.iso \
			> $$XDG_CACHE_HOME/arch-installation/archlinux.iso.tmp; \
		mv $$XDG_CACHE_HOME/arch-installation/archlinux.iso{.tmp,}; \
	fi
	mv $$XDG_CACHE_HOME/arch-installation/archlinux.sig{.tmp,}
	@echo -e "\nCheck the PGP signature"
	pacman-key -v $$XDG_CACHE_HOME/arch-installation/archlinux{.sig,.iso}
	@echo -e "\nCheck the name of a USB drive"
	ls -l /dev/disk/by-id/usb-*
	@read -p "OK? [y/n]" ans; if [ $$ans != y ]; then exit 1; fi;
	@echo -e "\nEnsure that the USB drive is not mounted"
	lsblk
	@read -p "OK? [y/n]" ans; if [ $$ans != y ]; then exit 1; fi;
	@read -p "Enter the USB drive without suffix (e.g. /dev/sdb): " usb; \
	sudo cp $$XDG_CACHE_HOME/arch-installation/archlinux.iso $$usb

