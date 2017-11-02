#!/bin/bash

export DISPLAY=:0.0
# usermod -a -G video pi


echo "pre x"
#rm ~/.Xauthority
python /home/pi/screenly/server.py
startx /usr/bin/python /home/pi/screenly/viewer.py
# umount /dev/shm && mount -t tmpfs shm /dev/shm
# rm /tmp/.X0-lock &>/dev/null || true

# su - pi -c "unset XAUTHORITY; xauth add $(xauth list)"
# startx &

# xset q &>/dev/null
# xset_is_ready=$?
# while [ "$xset_is_ready" != "0" ]; do
# 	xset q &>/dev/null
# 	xset_is_ready=$?
#     echo "xset q returned $xset_is_ready. Waiting for 1 s..."
#     sleep 1
# done

# su - pi -c "/usr/bin/matchbox-window-manager -use_titlebar no -use_cursor no"
# su - pi -c "python /home/pi/screenly/websocket_server_layer.py" &
# su - pi -c "python /home/pi/screenly/server.py" &
# su - pi -c "python /home/pi/screenly/viewer.py"


