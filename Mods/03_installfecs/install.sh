#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [installfecs] script..."

if [[ -e /fs/sda0 ]]; then
	mount -uw /fs/sda0
	modPath=/fs/sda0
	echo "Mounted SD1 card in r/w mode"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	modPath=/fs/sdb0
	echo "Mounted SD2 card in r/w mode"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	modPath=/fs/usb0_0
	echo "Mounted USB1 drive in r/w mode"
else
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e $modPath/backup ]] && mkdir $modPath/backup
[[ ! -e $modPath/backup ]] && echo "Error: cannot create $modPath/backup folder!" && exit 1

echo "Mounting /mnt/app in r/w mode..."
[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
mount -uw /mnt/app

echo "Mounting /mnt/swup in r/w mode..."
[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
mount -uw /mnt/swup/

echo "Mounting /mnt/persist_new in r/w mode..."
[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new
mount -uw /mnt/persist_new

echo "Backup fecmanager..."
[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -fV /mnt/app/eso/bin/apps/fecmanager $modPath/backup/

#1 Скопировать fecmanager в /mnt/app/eso/bin/apps/ с заменой
echo "Replacing /mnt/app/eso/bin/apps/fecmanager"
cp -fV $modPath/Storage/installfecs/fecmanager /mnt/app/eso/bin/apps/fecmanager
chmod 755 /mnt/app/eso/bin/apps/fecmanager

#2 Скопировать fecmanager в /mnt/swup/eso/bin/apps/ с заменой
echo "Replacing /mnt/swup/eso/bin/apps/fecmanager"
cp -Vf $modPath/Storage/installfecs/fecmanager /mnt/swup/eso/bin/apps/fecmanager
chmod 755 /mnt/swup/eso/bin/apps/fecmanager

#3 Скопирповать ExceptionList.txt в /mnt/persist_new/fec/ExceptionList.txt с заменой
echo "Copy /mnt/persist_new/fec/ExceptionList.txt"
cp -Vf $modPath/Storage/installfecs/ExceptionList.txt /mnt/persist_new/fec/ExceptionList.txt

#4 FoD=SwaP
echo "Script set FoD=SwaP flag by [enablegem] mod"

sync
sync

echo "Done."