#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3_listjars] script..."

# /mnt/app/eso/hmi/engdefs
# /eso/hmi/lsd/jars
# eso/

. /eso/hmi/engdefs/scripts/q3t_common.sh 
 

mount_device 
ensure_backup_dir

if [[ -z "$BACKUPDIR" || ! -d "$BACKUPDIR" ]]; then
    echo "[ERR] BACKUPDIR not set or dir not found!"
    exit 1
fi

JAR_PATH="/eso/hmi/lsd/jars"

echo "Listing JAR files in $JAR_PATH :"
echo

if [[ ! -d "$JAR_PATH" ]]; then
    echo "[ERR] $JAR_PATH not found!"
    exit 1
fi


ls -la "$JAR_PATH"
ls -la "$JAR_PATH" > "$BACKUPDIR/jar_list.txt"

echo
echo "JAR file list saved to $BACKUPDIR/jar_list.txt"
echo "Done."