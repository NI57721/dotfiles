#!/bin/bash -u

vim_root=$XDG_DATA_HOME/vim
mkdir -p $vim_root
if [ "$(git -C $vim_root rev-parse --is-inside-work-tree 2>/dev/null)" = true ]; then
  git -C $vim_root pull
else
  git clone https://github.com/vim/vim.git $vim_root
fi

cd $vim_root
./configure \
  --with-features=huge --enable-gui=gtk3 --enable-perlinterp \
  --enable-python3interp --enable-rubyinterp --enable-luainterp \
  --with-luajit --enable-fail-if-missing
make

