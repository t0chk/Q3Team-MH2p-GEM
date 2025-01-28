#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

if [[ -e /fs/sda0 ]]; then
	mount -uw /fs/sda0
	dstPath=/fs/sda0
	echo "Mounted SD1 card in r/w mode"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	dstPath=/fs/sdb0
	echo "Mounted SD2 card in r/w mode"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	dstPath=/fs/usb0_0
	echo "Mounted USB1 drive in r/w mode"
else
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

[[ ! -e $dstPath/backup ]] && mkdir $dstPath/backup
[[ ! -e $dstPath/backup ]] && echo "Error: cannot create $dstPath/backup folder!" && exit 1

s="Creating backup...";echo $s;echo $s >> $dstPath/backup/device_info.txt

[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "$(date)" >> $dstPath/backup/device_info.txt
echo "Variant: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)" >> $dstPath/backup/device_info.txt
echo "SW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF187 | awk '{print $13}' 2>/dev/null) HW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF191 | awk '{print $13}' 2>/dev/null)" >> $dstPath/backup/device_info.txt

echo "5F coding: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
echo "5F adaptations: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt

[[ -e "/mnt/gracenotedb/database/rev.txt" ]] && echo "GracenoteDB: $(cat /mnt/gracenotedb/database/rev.txt)" >> $dstPath/backup/device_info.txt

echo "Mounts:" >> $dstPath/backup/device_info.txt 2>/dev/null
mount >> $dstPath/backup/device_info.txt 2>/dev/null

ls -alR / >> $dstPath/backup/device_info.txt 2>/dev/null

cp -rf /mnt/persist_new $dstPath/backup/

[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -f /mnt/app/eso/bin/apps/fecmanager $dstPath/backup/
[[ -e /mnt/app/eso/bin/apps/componentprotection ]] && cp -f /mnt/app/eso/bin/apps/componentprotection $dstPath/backup/
[[ -e /mnt/app/eso/hmi/lsd/lsd.jar ]] && cp -f /mnt/app/eso/hmi/lsd/lsd.jar $dstPath/backup/

[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
cp -f /mnt/swup/etc/passwd $dstPath/backup/
cp -f /mnt/swup/etc/shadow $dstPath/backup/


[[ ! -e "/mnt/system" ]] && mount -o noatime,nosuid,noexec -r /dev/fs0p1 /mnt/system
s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt