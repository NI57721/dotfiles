#!/usr/bin/env sh

if ip a | grep "scope global \w\+\$" > /dev/null; then
  echo VPN
fi

