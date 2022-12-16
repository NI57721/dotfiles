.DEFAULT_GOAL := help
.PHONY: all allinstall

PACKAGES := curl git python3 python3-pip tmux todotxt-cli vim-gtk3

ADD_REPOSITORY = sudo apt-add-repository ppa:
INSTALL_PKG    = sudo apt-get -y install
REMOVE_PKG     = sudo apt-get -y remove
UPDATE_PKG     = sudo apt-get -y update

PROJECT_PATH = ~/ ## WIP
SKK_DIC_PATH = ~/.skkabcdefghijklmn

LINKED_FILES = a b c ## WIP

help: ## Display this message.
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sort \
	| awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

all: ## Execute install and initialize.
	install
	initialize

backup: ## Make backups of data.
create_links: ## Create links of data.

initialize: init_git ## Initialize settings for some software.

init_git: ## Initialize settings for git.
	git config --global user.email "104410688+NI57721@users.noreply.github.com"
	git config --global user.name "NI57721"
	git config --global core.pager cat
	git config --global init.defaultBranch main

install: i_packages i_deno i_docker i_fish i_fisher i_go i_rbenv i_rust i_skk_dictionaries i_tpm i_trash_cli ## Install everything needed.
install_optional: i_virtualbox_ga ## Install a tools for guest OSs on VirtualBox.

install_packages: ## Install packages.
	$(ADD_REPOSITORY)jonathonf/vim
	$(UPDATE_PKG)
	$(INSTALL_PKG) $(PACKAGES)

i_deno: ## Install deno.
	curl -fsSL https://deno.land/x/install/install.sh | sh

i_docker: ## Install docker.
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

i_fish: ## Install fish shell.
	$(ADD_REPOSITORY)fish-shell/release-3
	$(UPDATE_PKG)
	$(INSTALL_PKG) fish

i_fisher: i_fish ## Install fisher.
	curl -sL https://git.io/fisher | source
	fish -c "fisher update"

i_go: ## Install go.
	echo "Check the tar file URL from the below page."
	echo "https://go.dev/dl/"
	read -p "echo -e \"Tar file URL: \"" GO_URL \
	&& FNAME=$$(echo $$GO_URL | sed -e "s/.*\///g") \
	&& curl -L $$GO_URL > $$FNAME \
	&& sudo rm -rf /usr/local/go \
	&& sudo tar -C /usr/local -xzf $$FNAME \
	&& rm $$FNAME

i_nvm: ## Install nvm.
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.2/install.sh | bash

i_rbenv: ## Install rbenv.
	git clone https://github.com/rbenv/rbenv.git ~/.rbenv
	cd ~/.rbenv && src/configure && make -C src
	~/.rbenv/bin/rbenv init
	mkdir -p $$(rbenv root)/plugins
	git clone https://github.com/rbenv/ruby-build.git $$(rbenv root)/plugins/ruby-build
	curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | sh

i_rust: ## Install rust
	curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

i_skk_dictionaries: ## Install dictionary files for skk.
	mkdir $(SKK_DIC_PATH)
	wget -P $(SKK_DIC_PATH) https://skk-dev.github.io/dict/SKK-JISYO.L.gz
	wget -P $(SKK_DIC_PATH) https://skk-dev.github.io/dict/SKK-JISYO.jinmei.gz
	wget -P $(SKK_DIC_PATH) https://skk-dev.github.io/dict/SKK-JISYO.geo.gz
	wget -P $(SKK_DIC_PATH) https://skk-dev.github.io/dict/SKK-JISYO.station.gz
	wget -P $(SKK_DIC_PATH) https://skk-dev.github.io/dict/SKK-JISYO.propernoun.gz
	wget -P $(SKK_DIC_PATH) https://skk-dev.github.io/dict/zipcode.tar.gz
	wget -P $(SKK_DIC_PATH) https://raw.githubusercontent.com/uasi/skk-emoji-jisyo/master/SKK-JISYO.emoji.utf8
	find $(SKK_DIC_PATH) -name "*.gz" | xargs -I{} gzip -d {}
	tar -xf $(SKK_DIC_PATH)/zipcode.tar -C $(SKK_DIC_PATH) && rm $(SKK_DIC_PATH)/zipcode.tar

i_tpm: ## Install tpm.
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

i_trash_cli: install_packages ## Install trash-cli.
	python3 -m pip install trash-cli

i_virtualbox_ga: ## Install VirtualBox Guest Additions.
	$(UPDATE_PKG)
	$(INSTALL_APT) xserver-xorg xserver-xorg-core
	sudo mount /dev/cdrom /mnt
	sudo sh /mnt/VBoxLinuxAdditions.run

