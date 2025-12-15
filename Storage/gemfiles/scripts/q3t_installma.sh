#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Install [mirrorapp] files..."

CUSTOM=dcm/AATest2.jar
CUSTOM2=dcm/mh2p-opengl-render
CPPLIB=lib/libcpp.so.5
DSTPATH=/mnt/app/eso

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

if [[ ! -e "$MODPATH/Storage/$CUSTOM" ]]; then
  echo "[ERR] cannot find $CUSTOM in $MODPATH/Storage"
  exit 1
fi

if [[ ! -e "$MODPATH/Storage/$CUSTOM2" ]]; then
  echo "[ERR] cannot find $CUSTOM2 in $MODPATH/Storage"
  exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

cp -fV $MODPATH/Storage/$CUSTOM $DSTPATH/hmi/lsd/jars/
cp -fV $MODPATH/Storage/$CUSTOM2 $DSTPATH/bin/apps/dataconnectionmanager

chmod 755 $DSTPATH/bin/apps/dataconnectionmanager

if [[ ! -e $DSTPATH/$CPPLIB ]]; then
	echo "Copying CPPLIB..."
	cp -fV $MODPATH/Storage/$CPPLIB $DSTPATH/$CPPLIB
	chmod 755 $DSTPATH/$CPPLIB
else
	echo "$CPPLIB found!"
fi

sync
sync

echo "Reboot unit to apply changes!"
echo "Done."