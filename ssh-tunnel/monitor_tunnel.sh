#!/bin/bash

#set -xv
source variables.sh

exec > >(awk '{ print strftime("%Y-%m-%d %H:%M:%S"), $0; }' >> $LOG_SSH_TUNNEL_MONITOR) 2>&1

# Find PID 
PID=$(ps aux | grep "ssh"|grep ${REMOTE_USER}@${REMOTE_HOST}|awk '{print $2}')

if kill -0 $PID 2>/dev/null; then
    echo "Tunnel is up"
else
    echo "Tunnel is down, trying start"
    ssh  -p ${REMOTE_PORT} ${REMOTE_USER}@${REMOTE_HOST} "ip link delete tun0"
    
    "$PATH_START_TUNNEL"
fi