#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [Fast FullScreenAACPCL_test1 install From USB] script..."

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

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

if [[ ! -e "$LSD_JARS_PATH/FullScreenAACPCL.jar" ]]; then
	echo "Activating FullScreenAACPCL_test1 mod..."
    cp -Vf $MODPATH/Storage/jars/FullScreenAACPCL_test1.jar $LSD_JARS_PATH/FullScreenAACPCL.jar
else
    echo "Disabling previously installed FullScreen mod... "
    rm -f $LSD_JARS_PATH/FullScreenAACPCL.jar
    echo "Activating FullScreenAACPCL_test1 mod..."
    cp -Vf $MODPATH/Storage/jars/FullScreenAACPCL_test1.jar $LSD_JARS_PATH/FullScreenAACPCL.jar
fi

sync
sync
sync

echo "Done. Reboot the unit or install new skin."