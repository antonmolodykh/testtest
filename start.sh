#!/bin/bash
export DISPLAY=:0.0

echo $DISPLAY

rm /tmp/.X0-lock &>/dev/null || true
sudo -u pi /usr/local/bin/python /home/pi/screenly/viewer.py
startx 