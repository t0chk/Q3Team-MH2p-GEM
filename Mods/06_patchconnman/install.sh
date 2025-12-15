#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [patchconnman] script..."

if [[ -e /fs/sda0 ]]; then
	mount -uw /fs/sda0
	MODPATH=/fs/sda0
	echo "Mounted SD1 card in r/w mode"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	MODPATH=/fs/sdb0
	echo "Mounted SD2 card in r/w mode"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	MODPATH=/fs/usb0_0
	echo "Mounted USB1 drive in r/w mode"
else
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

PATCHPATH="$MODPATH/Storage/patch"

if [[ ! -e "$PATCHPATH/connectionmanager" ]]; then
  echo "Error: cannot find $PATCHPATH/connectionmanager"
  exit 1
fi

echo "Copying connectionmanager to /mnt/app/eso/bin/apps/ ..."
cp -fV $PATCHPATH/connectionmanager /mnt/app/eso/bin/apps/connectionmanager
chmod 755 /mnt/app/eso/bin/apps/connectionmanager
