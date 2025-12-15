#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t exlist update] script..."

. /eso/hmi/engdefs/scripts/q3t_common.sh 
 

mount_device 
ensure_backup_dir

if [[ -z "$BACKUPDIR" || ! -d "$BACKUPDIR" ]]; then
    echo "[ERR] BACKUPDIR not set or dir not found!"
    exit 1
fi

if [[ ! -e "$MODPATH/Storage/installfecs/ExceptionList.txt" ]]; then
	echo "[ERR] ExceptionList.txt not found in [$MODPATH]"
	exit 1
fi

echo "Mounting /mnt/persist_new in r/w mode..."
[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new
mount -uw /mnt/persist_new

#Вытащить текущий ExceptionList.txt в backup
echo "Copy current /mnt/persist_new/fec/ExceptionList.txt to backup"
cp -Vf /mnt/persist_new/fec/ExceptionList.txt $MODPATH/backup/ExceptionList.txt

#Скопирповать ExceptionList.txt в /mnt/persist_new/fec/ExceptionList.txt с заменой
echo "Copy /mnt/persist_new/fec/ExceptionList.txt"
cp -Vf $MODPATH/Storage/installfecs/ExceptionList.txt /mnt/persist_new/fec/ExceptionList.txt

echo "ExceptionList.txt updated successfully."
echo "Please reboot the system to apply changes."

sync
sync