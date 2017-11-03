#!/bin/bash

mkdir /data/screenly /data/.screenly /data/screenly_assets /data/.config /data/.config/uzbl
cp -n ansible/roles/screenly/files/screenly.conf /data/.screenly/screenly.conf
cp -n ansible/roles/screenly/files/screenly.db /data/.screenly/screenly.db
cp -n loading.png /data/screenly/loading.png
cp -n ansible/roles/screenly/files/uzbl-config /data/.config/uzbl/config-screenly

chown -R pi:pi /data

export DISPLAY=:0.0
usermod -a -G video pi

# By default docker gives us 64MB of shared memory size but to display heavy
# pages we need more.
umount /dev/shm && mount -t tmpfs shm /dev/shm

su - pi -c "HOME=/data python /home/pi/screenly/server.py" &
/usr/bin/X &
su - pi -c "/usr/bin/matchbox-window-manager -use_titlebar no -use_cursor no" &

export NOREFRESH=1
su - pi -c "/usr/bin/xset s off"
su - pi -c "/usr/bin/xset -dpms"
su - pi -c "/usr/bin/xset s noblank"
su - pi -c "DISABLE_UPDATE_CHECK=True HOME=/data python /home/pi/screenly/viewer.py"&
su - pi -c "/bin/rm -f /tmp/uzbl_*"
su - pi -c "/bin/rm -f /tmp/screenly_html/*"

su - pi -c "HOME=/data python /home/pi/screenly/websocket_server_layer.py"
