#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t gem update] script..."

GEMPATH=/mnt/app/eso/hmi/engdefs

if [[ -e /fs/sda0 ]]; then
	MODPATH=/fs/sda0
	echo "Use SD1 card as source"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	MODPATH=/fs/sdb0
	echo "Use SD2 card as source"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	MODPATH=/fs/usb0_0
	echo "Use USB1 drive as source"
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app as dest..."
mount -uw /mnt/app

if [[ ! -e "$MODPATH/Storage/enablegem/doas.conf" ]]; then
	echo "[ERR] doas.conf not found in [$MODPATH]/Storage/enablegem"
	exit 1
fi

rm -f $GEMPATH/0x600_longcoding.esd
rm -f $GEMPATH/q3*.esd
rm -rf $GEMPATH/scripts/q3*.sh
rm -rf /mnt/ota/gem_jars/*

cp -fv $MODPATH/Storage/enablegem/doas.conf /mnt/ota/
chmod 444 /mnt/ota/doas.conf

cp -fRV $MODPATH/Storage/gemfiles/. $GEMPATH
chmod 755 $GEMPATH/scripts/*

[[ ! -e /mnt/ota/gem_jars ]] && mkdir /mnt/ota/gem_jars
cp -fRV $MODPATH/Storage/jars/. /mnt/ota/gem_jars

sync
sync
sync