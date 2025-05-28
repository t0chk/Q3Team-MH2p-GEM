#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [backup] script..."

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

[[ ! -e $MODPATH/backup ]] && mkdir $MODPATH/backup
[[ ! -e $MODPATH/backup ]] && echo "Error: cannot create $MODPATH/backup folder!" && exit 1

#sloginfo
echo "get sloginfo to $MODPATH/backup/sloginfo.txt ..."
sloginfo > $MODPATH/backup/sloginfo.txt

s="Creating backup...";echo $s;echo $s >> $MODPATH/backup/device_info.txt

[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Variant: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)" >> $MODPATH/backup/device_info.txt
echo "SW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF187 | awk '{print $13}' 2>/dev/null) HW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF191 | awk '{print $13}' 2>/dev/null)" >> $MODPATH/backup/device_info.txt

cat /dev/nvsku/uid >> $MODPATH/backup/device_info.txt
cat /dev/shmem/vehicleinventory >> $MODPATH/backup/device_info.txt

echo "5F coding: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $MODPATH/backup/device_info.txt
echo "5F adaptations: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $MODPATH/backup/device_info.txt

echo "Mounts:" >> $MODPATH/backup/device_info.txt 2>/dev/null
mount >> $MODPATH/backup/device_info.txt 2>/dev/null

ls -alR / >> $MODPATH/backup/device_info.txt 2>/dev/null

cp -rfV /mnt/persist_new $MODPATH/backup/

[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -fV /mnt/app/eso/bin/apps/fecmanager $MODPATH/backup/
[[ -e /mnt/app/eso/bin/apps/componentprotection ]] && cp -fV /mnt/app/eso/bin/apps/componentprotection $MODPATH/backup/
[[ -e /mnt/app/eso/bin/servicemgrmibhigh ]] && cp -fV /mnt/app/eso/bin/servicemgrmibhigh $MODPATH/backup/
[[ -e /mnt/app/eso/bin/servicemgrmibhigh0 ]] && cp -fV /mnt/app/eso/bin/servicemgrmibhigh0 $MODPATH/backup/
[[ -e /mnt/app/eso/bin/servicemgrmibhigh99 ]] && cp -fV /mnt/app/eso/bin/servicemgrmibhigh99 $MODPATH/backup/

[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
cp -fV /mnt/swup/etc/passwd $MODPATH/backup/
cp -fV /mnt/swup/etc/shadow $MODPATH/backup/

[[ ! -e "/mnt/system" ]] && mount -o noatime,nosuid,noexec -r /dev/fs0p1 /mnt/system
s="Done.";echo $s;echo $s >> $MODPATH/backup/device_info.txt

# Работа с crashlogs
[[ ! -e $MODPATH/crashlogs ]] && mkdir $MODPATH/crashlogs
[[ ! -e $MODPATH/crashlogs ]] && echo "Error: cannot create $MODPATH/crashlogs folder!" && exit 1

echo "Copying crashlogs to $MODPATH/crashlogs/ ..."
cp -rfV /mnt/crashlogs/ $MODPATH/crashlogs/
