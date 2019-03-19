#!/bin/bash
set -e

# If variables don't exist get from /variables
if [ ${#HUB_ADDRESS} -lt 1 ]; then
	export HUB_ADDRESS=$(cat /variables/HUB_ADDRESS)
fi

if [ ${#HUB_PORT} -lt 1 ]; then
        export HUB_PORT=$(cat /variables/HUB_PORT)
fi

exec /sbin/setuser selenium selenium-side-runner -s http://${HUB_ADDRESS}:${HUB_PORT} --output-directory /out /sides/*.side >> /var/log/selenium.log 2>&1
