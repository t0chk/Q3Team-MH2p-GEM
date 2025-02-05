#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [backup] script..."

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

#sloginfo
echo "get sloginfo to $dstPath/backup/sloginfo.txt ..."
sloginfo > $dstPath/backup/sloginfo.txt

s="Creating backup...";echo $s;echo $s >> $dstPath/backup/device_info.txt

[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Variant: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)" >> $dstPath/backup/device_info.txt
echo "SW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF187 | awk '{print $13}' 2>/dev/null) HW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF191 | awk '{print $13}' 2>/dev/null)" >> $dstPath/backup/device_info.txt

echo "5F coding: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt
echo "5F adaptations: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $dstPath/backup/device_info.txt

echo "Mounts:" >> $dstPath/backup/device_info.txt 2>/dev/null
mount >> $dstPath/backup/device_info.txt 2>/dev/null

ls -alR / >> $dstPath/backup/device_info.txt 2>/dev/null

cp -rfV /mnt/persist_new $dstPath/backup/

[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -fV /mnt/app/eso/bin/apps/fecmanager $dstPath/backup/
[[ -e /mnt/app/eso/bin/apps/componentprotection ]] && cp -fV /mnt/app/eso/bin/apps/componentprotection $dstPath/backup/
[[ -e /mnt/app/eso/bin/servicemgrmibhigh ]] && cp -fV /mnt/app/eso/bin/servicemgrmibhigh $dstPath/backup/
[[ -e /mnt/app/eso/bin/servicemgrmibhigh0 ]] && cp -fV /mnt/app/eso/bin/servicemgrmibhigh0 $dstPath/backup/
[[ -e /mnt/app/eso/bin/servicemgrmibhigh99 ]] && cp -fV /mnt/app/eso/bin/servicemgrmibhigh99 $dstPath/backup/

[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
cp -fV /mnt/swup/etc/passwd $dstPath/backup/
cp -fV /mnt/swup/etc/shadow $dstPath/backup/

[[ ! -e "/mnt/system" ]] && mount -o noatime,nosuid,noexec -r /dev/fs0p1 /mnt/system
s="Done.";echo $s;echo $s >> $dstPath/backup/device_info.txt

# Работа с crashlogs
[[ ! -e $dstPath/crashlogs ]] && mkdir $dstPath/crashlogs
[[ ! -e $dstPath/crashlogs ]] && echo "Error: cannot create $dstPath/crashlogs folder!" && exit 1

cp -rfV /mnt/crashlogs/ $dstPath/crashlogs/
