#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [mirrorapp] script..."

CUSTOM=jars/AATest2.jar
CUSTOM2=dcm/mh2p-opengl-render

CPPLIB=libcpp.so.5
DSTPATH=/mnt/app/eso

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

cp -fV $MODPATH/Storage/$CUSTOM $DSTPATH/hmi/lsd/jars/
cp -fV $MODPATH/Storage/$CUSTOM2 $DSTPATH/bin/apps/dataconnectionmanager

chmod 755 $DSTPATH/bin/apps/dataconnectionmanager

if [[ ! -e "$DSTPATH/lib/$CPPLIB" ]]; then
	echo "Copying CPPLIB..."
	cp -fV $MODPATH/Storage/lib/$CPPLIB $DSTPATH/lib/$CPPLIB
	chmod 755 $DSTPATH/lib/$CPPLIB
else
	echo "$CPPLIB found!"
fi

sync
sync

echo "[mirrorapp] done."
