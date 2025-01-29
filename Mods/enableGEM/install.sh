#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

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
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app as dest..."
mount -uw /mnt/app

if [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh0" ]]; then
    cp /mnt/app/eso/bin/servicemgrmibhigh /mnt/app/eso/bin/servicemgrmibhigh0
    cp -f $srcPath/Storage/01/servicemgrmibhigh /mnt/app/eso/bin/
    chmod 755 /mnt/app/eso/bin/servicemgrmibhigh
    echo "enable GEM [OK]"
fi

echo "Unmounting /mnt/app..."
sync
[[ -e "/mnt/app" ]] && umount -f /mnt/app

[[ ! -e "/mnt/ota" ]] &&  mount -t qnx6 /dev/mnanda0t177.16 /mnt/ota
echo "Mounting /mnt/ota as dest..."
mount -uw /mnt/ota

cp -f $srcPath/Storage/01/challenge.pub /mnt/ota/
cp -f $srcPath/Storage/01/doas.conf /mnt/ota/