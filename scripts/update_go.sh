#!/bin/bash -u

echo Looking up latest version
version=$(go version 2> /dev/null | sed -e "s/^.*\(go[0-9.]\+\).*/\1/g")
latest_version=$(curl --silent https://go.dev/VERSION?m=text | head -1)
if [[ "$version" == "$latest_version" ]]; then
  echo "Local go version $version is the most recent release"
  exit 0
fi
curl -L https://go.dev/dl/$latest_version.linux-amd64.tar.gz > /tmp/latest_go.tar.gz
if [ -d $XDG_DATA_HOME/go ]; then rm -rf $XDG_DATA_HOME/go; fi
mkdir -p $XDG_DATA_HOME/go
tar -C $XDG_DATA_HOME -xzf /tmp/latest_go.tar.gz && rm /tmp/latest_go.tar.gz

