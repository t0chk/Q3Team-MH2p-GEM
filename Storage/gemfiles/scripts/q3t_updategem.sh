#!/bin/ksh

echo "Starting of [q3t gem update] script..."

if [[ -e /fs/sda0 ]]; then
	modPath=/fs/sda0
	echo "Use SD1 card as source"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	modPath=/fs/sdb0
	echo "Use SD2 card as source"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	modPath=/fs/usb0_0
	echo "Use USB1 drive as source"
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi

# Монтирование точек
[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app as dest..."
mount -uw /mnt/app

if [[ ! -e "$modPath/Storage/enablegem/doas.conf" ]]; then
	echo "[ERR] doas.conf not found in [$modPath]/Storage/enablegem"
	exit 1
fi

cp -fv $modPath/Storage/enablegem/doas.conf /mnt/ota/
chmod 444 /mnt/ota/doas.conf

cp -fRV $modPath/Storage/gemfiles/. /mnt/app/eso/hmi/engdefs
chmod 755 /mnt/app/eso/hmi/engdefs/scripts/*

sync
sync