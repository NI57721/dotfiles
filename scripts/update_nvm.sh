#!/bin/bash -u

mkdir -p $NVM_DIR
mkdir -p $XDG_DATA_HOME/node

if [ $(git -C $NVM_DIR rev-parse --is-inside-work-tree 2>/dev/null) == true ]; then
  git -C $NVM_DIR fetch --all
else
  git clone https://github.com/nvm-sh/nvm.git $NVM_DIR
fi

cd $NVM_DIR
latest_commit=$(git rev-list --tags --max-count=1)
latest_tag=$(git describe --abbrev=0 --tags --match "v[0-9]*" $latest_commit)
git switch --detach $latest_tag
. ./nvm.sh
nvm install node
nvm install-latest-npm

nodes_path=$NVM_DIR/versions/node
mkdir -p $nodes_path
for node_path in $NVM_DIR/versions/node/v*; do
  basename $node_path >> $nvm_data/.index
done
sort $nodes_path/.index | uniq > $nodes_path/.index_
mv $nodes_path/.index{_,}

