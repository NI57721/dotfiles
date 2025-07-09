#!/bin/bash -eu

echo Looking up latest version
version=$(go version 2> /dev/null | sed -e "s/^.*\(go[0-9.]\+\).*/\1/g")
latest_version=$(curl --silent https://go.dev/VERSION?m=text | head -1)
if [ "$version" = "$latest_version" ]; then
  echo "Local go version $version is the most recent release"
  exit 0
fi

tmp_file=mktemp
curl -L -o $tmp_file https://go.dev/dl/$latest_version.linux-amd64.tar.gz
go_root=$XDG_DATA_HOME/go
if [ -d "$go_root" ]; then
  rm -rf $go_root
fi
mkdir -p $go_root
tar -C $XDG_DATA_HOME -xzf $tmp_file && rm $tmp_file

