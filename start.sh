#!/bin/bash

export DISPLAY=:0.0
usermod -a -G video pi
usermod -a -G tty pi

umount /dev/shm && mount -t tmpfs shm /dev/shm

cp /etc/hosts ~/hosts.new
sed -i "s/localhost.localdomain/$HOSTNAME/" ~/hosts.new
cat ~/hosts.new > /etc/hosts


echo "pre x"
echo $DISABLE_UPDATE_CHECK


rm /tmp/.X0-lock &>/dev/null || true

su - pi -c "unset XAUTHORITY; xauth add $(xauth list)"
su - pi -c "python /home/pi/screenly/websocket_server_layer.py" &
su - pi -c "python /home/pi/screenly/server.py" &
startx &

xset q &>/dev/null
xset_is_ready=$?
while [ "$xset_is_ready" != "0" ]; do
  xset q &>/dev/null
  xset_is_ready=$?
    echo "xset q returned $xset_is_ready. Waiting for 1 s..."
    sleep 1
done
#su - pi -c "/usr/bin/matchbox-window-manager -use_titlebar no -use_cursor no"
su - pi -c "DISABLE_UPDATE_CHECK=True python /home/pi/screenly/viewer.py"
