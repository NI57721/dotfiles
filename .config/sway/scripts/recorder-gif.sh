#!/bin/bash -u

if [ -z $(ps aux | grep -v grep | grep wf-recorder) ]; then
  notify-send -t 1000 "Start recording"
  wf-recorder -g "$(slurp)" -F fps=30 -c gif -f $HOME/$(date "+%Y%m%d-%H%M%S-%N").gif
else
  killall -s SIGINT -e wf-recorder
  notify-send -t 1000 "Stop recording"
fi

