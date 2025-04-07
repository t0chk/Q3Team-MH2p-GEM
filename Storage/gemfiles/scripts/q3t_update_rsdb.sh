#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [Update RSDB (radiostation logo database) from SD/USB] script..."

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

if [[ ! -e "$MODPATH/VW_STL_DB.sqlite" ]]; then
	echo "[ERR] RSDB database not found in [$MODPATH]/"
	echo "To fix - copy VW_STL_DB.sqlite to the root directory of your SD/USB"
	exit 1
fi

[[ ! -e "/mnt/misc1" ]] && mount -t qnx6 /dev/mnanda0t177.4 /mnt/misc1
mount -uw /mnt/misc1

echo "Copying VW_STL_DB.sqlite to /mnt/misc1/rsdb/..."
cp -Vf $MODPATH/VW_STL_DB.sqlite /mnt/misc1/rsdb/
echo "Done."