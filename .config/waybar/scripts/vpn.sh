#!/usr/bin/env sh

if ip address | grep "^[0-9]\+: wg0: " > /dev/null; then
  echo VPN
fi

