#!/bin/bash
set -e

# If variables don't exist get from /variables
if [ ${#HUB_ADDRESS} -lt 1 ]; then
	export HUB_ADDRESS=$(cat /variables/HUB_ADDRESS)
fi

if [ ${#HUB_PORT} -lt 1 ]; then
        export HUB_PORT=$(cat /variables/HUB_PORT)
fi

cd /home/selenium
exec /sbin/setuser selenium selenium-side-runner -w 1 -s http://${HUB_ADDRESS}:${HUB_PORT}/wd/hub --output-directory /out /sides/*.side

sleep 5m
