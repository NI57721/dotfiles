#!/usr/bin/env sh

if ip a | grep "scope global vti\w\+\$" > /dev/null; then
  echo VPN
fi

