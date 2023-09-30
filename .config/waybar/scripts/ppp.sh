#!/usr/bin/env sh

if ip a | grep ppp > /dev/null; then
  echo VPN
fi

