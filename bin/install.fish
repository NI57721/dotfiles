#!/usr/bin/env fish

set project_root (realpath (dirname (status dirname)))
set linked_files .vimrc .vim/rc/dein.toml .vim/rc/dein_lazy.toml .config/fish/config.fish .config/fish/config.fish.local .config/fish/fish_plugins .gitignore_global .tmux.conf .bashrc

function success
  echo "Success: $argv"
end

function failure
  echo "Failure: $argv"
end

function install_packages
  sudo add-apt-repository ppa:jonathonf/vim
  and sudo apt-get update
  and sudo apt-get install -y \
    git \
    todotxt-cli \
    vim-gtk3
  and success $history[1]
  or failure $history[1]
end

function backup
  set dir (date "+%Y%m%d-%H%M%S")
  for f in $linked_files
    set dirpath $project_root/.backup/$dir/
    mkdir -p $dirpath
    and mv ~/$f $dirpath
    and success mv ~/$f $dirpath
    or failure mv ~/$f $dirpath
  end
end

function create_links
  for f in $linked_files
    set filepath $project_root/$f
    and ln -snf $filepath ~/$f
    and success ln -snf $filepath ~/$f
    or failure ln -snf $filepath ~/$f
  end
end

function install_fisher
  curl -sL https://git.io/fisher | source; and fisher update
  and success fisher installation
  or failure fisher installation
end

function install_rbenv
  git clone https://github.com/rbenv/rbenv.git ~/.rbenv
  cd ~/.rbenv && src/configure && make -C src
  ~/.rbenv/bin/rbenv init
  mkdir -p (rbenv root)/plugins
  git clone https://github.com/rbenv/ruby-build.git (rbenv root)/plugins/ruby-build
  curl -fsSL https://github.com/rbenv/rbenv-installer/raw/main/bin/rbenv-doctor | bash
end

function init_git
  git config --global user.email "104410688+NI57721@users.noreply.github.com"
  git config --global user.name "NI57721"
  git config --global core.pager cat
  git config --global init.defaultBranch main
end

function install_docker
  # sudo apt-get remove docker docker-engine docker.io containerd runc
  sudo apt-get update
  and sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
  and sudo mkdir -p /etc/apt/keyrings
  and curl -fsSL https://download.docker.com/linux/ubuntu/gpg |
    sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
  and echo "deb [arch="(dpkg --print-architecture)" \
    signed-by=/etc/apt/keyrings/docker.gpg] \
    https://download.docker.com/linux/ubuntu "(lsb_release -cs)" stable" |
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  and sudo apt-get update
  and sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin
  and success Docker installation
  or failure Docker installation
  sudo groupadd docker
  sudo usermod -aG docker $USER
end

function install_trash_cli
  sudo apt-get update
  and sudo apt-get install -y python3
  and python3 -m pip install trash-cli
  and success install trash-cli
  or failure install trash-cli
end

function install_deno
  curl -fsSL https://deno.land/x/install/install.sh | sh
end

backup
create_links
install_fisher
install_rbenv
install_fisher
install_docker

