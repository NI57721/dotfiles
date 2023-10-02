#!/usr/bin/env sh

if ps aux | grep -v grep | grep wf-recorder; then
  echo Recording
fi

