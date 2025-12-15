#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Backup [mirrorapp] files..."

CUSTOM=AATest2.jar
CUSTOM2=mh2p-opengl-render
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

[[ ! -e $MODPATH/backup ]] && mkdir $MODPATH/backup
[[ ! -e $MODPATH/backup/dcm ]] && mkdir $MODPATH/backup/dcm

if [[ ! -e "$MODPATH/backup/dcm" ]]; then
  echo "[ERR] cannot create $MODPATH/backup/dcm folder!"
  exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app


cp -fV $DSTPATH/hmi/lsd/jars/$CUSTOM $MODPATH/backup/dcm
cp -fV $DSTPATH/bin/apps/dataconnectionmanager $MODPATH/backup/dcm/$CUSTOM2

echo "Done."