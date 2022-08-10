#!/usr/bin/env fish

set project_root (status dirname)/..
set allowed_files .vimrc .vim/rc/dein.toml .vim/rc/dein_lazy.toml .config/fish/config.fish .config/fish/fish_plugins .gitignore_global

function backup
  set dir (date "+%Y%m%d-%H%M%S")
  for f in $allowed_files
    set filepath $project_root/.backup/$dir/$f
    mkdir -p (dirname $filepath)
    cp ~/$f $filepath
  end
end

