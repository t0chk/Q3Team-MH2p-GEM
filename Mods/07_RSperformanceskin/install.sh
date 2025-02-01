#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

echo "Starting installation of Q3 configurable RS Performance skin..."

if [[ -e /fs/sda0 ]]; then
	srcPath=/fs/sda0
	echo "Use SD1 card as source"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	srcPath=/fs/sdb0
	echo "Use SD2 card as source"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	srcPath=/fs/usb0_0
	echo "Use USB1 drive as source"
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi



[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app
echo "Done."

echo "Adding RS Perfomance skin..."

if [[ -e "/mnt/app/eso/hmi/lsd/jars" ]]; then
    if [[ -f "$srcPath/Storage/jars/CombiSkinsRSPerfomance.jar" ]]; then
        echo "Copy jar..."
        cp -Vf $srcPath/Storage/jars/CombiSkinsRSPerfomance.jar /mnt/app/eso/hmi/lsd/jars/CombiSkins.jar
        echo "Done."
    else
        echo "Error: cannot find $srcPath/Storage/jars/CombiSkinsRSPerfomance.jar"
    fi
else
    echo "${RED}ERROR!${NORM} /mnt/app/eso/hmi/lsd/jars does not exist."
fi

echo "Unmounting /mnt/app..."

sync
[[ -e "/mnt/app" ]] && umount -f /mnt/app

echo "Done. Rebooting the unit."
