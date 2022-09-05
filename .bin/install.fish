#!/usr/bin/env fish

set project_root (realpath (dirname (status dirname)))
set linked_files .vimrc .vim/rc/dein.toml .vim/rc/dein_lazy.toml .config/fish/config.fish .config/fish/config.fish.local .config/fish/fish_plugins .gitignore_global

function backup
  set dir (date "+%Y%m%d-%H%M%S")
  for f in $linked_files
    set dirpath $project_root/.backup/$dir/
    mkdir -p $dirpath
    and mv ~/$f $dirpath
    and echo mv ~/$f $dirpath
  end
end

function create_links
  for f in $linked_files
    set filepath $project_root/$f
    and ln -snf $filepath ~/$f
    and echo ln -snf $filepath ~/$f
  end
end


backup
and create_links

