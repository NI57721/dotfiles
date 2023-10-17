#!/bin/bash -u

vim_root=$XDG_DATA_HOME/vim
mkdir -p $vim_root
cd $vim_root

if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = true ]; then
  git pull
else
  git clone https://github.com/vim/vim.git $vim_root
fi

./configure \
  --with-features=huge --enable-gui=gtk3 --enable-perlinterp \
  --enable-python3interp --enable-rubyinterp --enable-luainterp \
  --with-luajit --enable-fail-if-missing
make

