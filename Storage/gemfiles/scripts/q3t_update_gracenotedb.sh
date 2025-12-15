#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [Update Gracenote2 database from SD/USB] script..."

if [[ -e /fs/sda0 ]]; then
	MODPATH=/fs/sda0
	echo "Using SD1 card as source..."
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	MODPATH=/fs/sdb0
	echo "Using SD2 card as source..."
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	MODPATH=/fs/usb0_0
	echo "Using USB1 drive as source..."
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e "/mnt/gracenotedb" ]] && mount -t qnx6 /dev/mnanda0t177.9 /mnt/gracenotedb

if [[ -e $MODPATH/gracenotedb ]]; then
    [[ -e "/mnt/gracenotedb/database/rev.txt" ]] && echo "Revision of GracenoteDB before update: $(cat /mnt/gracenotedb/database/rev.txt)"

    echo "Copying $MODPATH/gracenotedb/* to /mnt/gracenotedb/..."
    mount -uw /mnt/gracenotedb
    cp -Vrf $MODPATH/gracenotedb/* /mnt/gracenotedb/
    echo "Done."

    [[ -e "/mnt/gracenotedb/database/rev.txt" ]] && echo "Revision of GracenoteDB after update: $(cat /mnt/gracenotedb/database/rev.txt)"
else
    echo "ERROR: Cannot open $MODPATH/gracenotedb folder - check that it exists on your SD/USB"
fi