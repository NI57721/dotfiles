#!/bin/bash -u

if [ -z $(ps aux | grep wf-recorder | head -n -3) ]; then
  notify-send -t 1000 "Start recording"
  wf-recorder -g "$(slurp)" -F fps=30 -c gif -f /tmp/$(date +%s%N).gif
else
  killall -s SIGINT -e wf-recorder
  notify-send -t 1000 "Stop recording"
fi

