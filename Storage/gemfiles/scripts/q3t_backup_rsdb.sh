#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [Backup RSDB (radiostation logo database) to SD/USB] script..."

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

[[ ! -e "/mnt/misc1" ]] && mount -t qnx6 /dev/mnanda0t177.4 /mnt/misc1

echo "Backing up /mnt/misc1/rsdb/VW_STL_DB.sqlite to $MODPATH/backup..."

[[ ! -e $MODPATH/backup ]] && mkdir $MODPATH/backup
[[ ! -e $MODPATH/backup ]] && echo "Error: cannot create $MODPATH/backup folder!" && exit 1

cp -Vf /mnt/misc1/rsdb/VW_STL_DB.sqlite $MODPATH/backup/

echo "Done."