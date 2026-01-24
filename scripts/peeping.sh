#!/bin/bash -eu

url="$1"

suffix=""
case "$url" in
  */*.*)
    suffix=".${url##*.}";;
esac

tmp=$(mktemp --suffix="$suffix")
chmod 600 "$tmp"

curl --fail --silent --show-error --location "$url" --output "$tmp"
vim -nRM "$tmp" >&0

echo "Do you want to proceed? [y/N]" >&2
read -r answer
case "$answer" in
  [yY])
    cat "$tmp";;
  *)
    echo;;
esac

