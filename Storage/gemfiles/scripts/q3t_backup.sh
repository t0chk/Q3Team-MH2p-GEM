#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [backup] script..."

. /eso/hmi/engdefs/scripts/q3t_common.sh 

mount_device 
ensure_backup_dir

if [[ -z "$BACKUPDIR" || ! -d "$BACKUPDIR" ]]; then
    echo "[ERR] BACKUPDIR not set or dir not found!"
    exit 1
fi

#sloginfo
echo "get sloginfo to $MODPATH/backup/sloginfo.txt ..."
sloginfo > $MODPATH/backup/sloginfo.txt
echo "sloginfo done"

echo "get process info to $MODPATH/backup/sloginfo.txt ..."
ps -A > $MODPATH/backup/ps.txt
echo "process info done"

PARAMS=$MODPATH/backup/params
mkdir -p "$PARAMS"
echo "Dumping params..."
addrs="512 576 640 1120 3488 11264 11520 12032 12288 13824 14592 15104 28672 32768"
for addr in $addrs; do
    hex=$(printf "%X" $addr)  # переводим в HEX
    echo "pc b:24372:$addr" > "$PARAMS/${hex}.bin"
done
echo "params dump done"

echo "get shmem to $MODPATH/backup/shmem ..."
cp -rfV /dev/shmem $MODPATH/backup/

echo "Copying persist_new to $MODPATH/backup/persist_new ..."
cp -rfV /mnt/persist_new $MODPATH/backup/

s="Creating backup...";echo $s;echo $s >> $MODPATH/backup/device_info.txt

[[ ! -d /mnt/app ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Variant: $(pc s:678364556:12 2>/dev/null)" >> $MODPATH/backup/device_info.txt
echo "SW: $(pc b:0x5F22:0xF187 | awk '{print $13}' 2>/dev/null) HW: $(pc b:0x5F22:0xF191 | awk '{print $13}' 2>/dev/null)" >> $MODPATH/backup/device_info.txt

echo "uid: $(cat /dev/nvsku/uid)" >> $MODPATH/backup/device_info.txt

echo "inventory:" >> $MODPATH/backup/device_info.txt
cat /dev/shmem/vehicleinventory >> $MODPATH/backup/device_info.txt

echo "get shmem to $MODPATH/backup/shmem ..."
cp -rfV /dev/shmem $MODPATH/backup/

echo "Copying persist_new to $MODPATH/backup/persist_new ..."
cp -rfV /mnt/persist_new $MODPATH/backup/

echo "get display info to $MODPATH/backup/display_info.txt ..."
/mnt/app/armle/usr/bin/dmdt gs > $MODPATH/backup/display_info.txt
/mnt/app/armle/usr/bin/dmdt gd >> $MODPATH/backup/display_info.txt

echo "get display info done."


echo "5F coding: $(pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $MODPATH/backup/device_info.txt
echo "5F adaptations: $(pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)" >> $MODPATH/backup/device_info.txt

echo "environment variables:" >> $MODPATH/backup/device_info.txt
env >> $MODPATH/backup/device_info.txt 2>/dev/null

echo "Mounts:" >> $MODPATH/backup/device_info.txt 2>/dev/null
mount >> $MODPATH/backup/device_info.txt 2>/dev/null

echo "get tree, be patient..."
ls -alR / >> $MODPATH/backup/device_info.txt 2>/dev/null

echo "copy additional files to $MODPATH/backup/ ..."

[[ -e /mnt/app/eso/bin/apps/connectionmanager ]] && cp -fV /mnt/app/eso/bin/apps/connectionmanager $MODPATH/backup/
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

echo "Copying crashlogs to $MODPATH/crashlogs/ ..."
cp -rfV /mnt/crashlogs/ $MODPATH/crashlogs/