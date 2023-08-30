#!/usr/bin/bash -u

if grep -q open /proc/acpi/button/lid/LID0/state; then
  swaymsg output "$1" enable
else
  swaymsg output "$1" disable
fi

