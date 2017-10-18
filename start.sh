#!/bin/bash

python server.py &
python websocket_server_layer.py &
python viewer.py
