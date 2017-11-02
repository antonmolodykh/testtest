#!/bin/bash

mkdir /data/screenly /data/.screenly /data/screenly_assets /data/.config /data/.config/uzbl
cp -n ansible/roles/screenly/files/screenly.conf /data/.screenly/screenly.conf
cp -n ansible/roles/screenly/files/screenly.db /data/.screenly/screenly.db
cp -n loading.png /data/screenly/loading.png
cp -n ansible/roles/screenly/files/uzbl-config /data/.config/uzbl/config-screenly
# cp -n ansible/roles/screenly/files/screenly_utils.sh /usr/local/bin/screenly_utils.sh
# cp -n ansible/roles/screenly/files/screenly_overrides /tmp/screenly_overrides
# echo 'pi ALL=NOPASSWD:/usr/local/bin/screenly_utils.sh' >> /etc/X11/xinit/xserverrc


chown -R pi:pi /data

export DISPLAY=:0.0
usermod -a -G video pi
usermod -a -G tty pi

umount /dev/shm && mount -t tmpfs shm /dev/shm

cp /etc/hosts ~/hosts.new
sed -i "s/localhost.localdomain/$HOSTNAME/" ~/hosts.new
cat ~/hosts.new > /etc/hosts


rm /tmp/.X0-lock &>/dev/null || true

su - pi -c "unset XAUTHORITY; xauth add $(xauth list)"
su - pi -c "HOME=/data python /home/pi/screenly/server.py" &
/usr/bin/X &

xset q &>/dev/null
xset_is_ready=$?
while [ "$xset_is_ready" != "0" ]; do
  xset q &>/dev/null
  xset_is_ready=$?
    echo "xset q returned $xset_is_ready. Waiting for 1 s..."
    sleep 1
done

export DISPLAY=:0.0
su - pi -c "/usr/bin/matchbox-window-manager -use_titlebar no -use_cursor no" &
# echo "POST WINDOWS MANAGER"
su - pi -c "DISABLE_UPDATE_CHECK=True HOME=/data python /home/pi/screenly/viewer.py"&
su - pi -c "HOME=/data python /home/pi/screenly/websocket_server_layer.py"
