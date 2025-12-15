#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Clear [mirrorapp] files..."

MAPATH=/mnt/app/eso

MA_JARS_PATH="$MAPATH/hmi/lsd/jars"
MA_BIN_PATH="$MAPATH/bin/apps"

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

if [[ ! -e "$MA_JARS_PATH/AATest2.jar" ]]; then
	echo "no JAR files found in $MA_JARS_PATH"
else
    echo "removing JAR files from $MA_JARS_PATH"
    rm -f $MA_JARS_PATH/AATest2.jar
fi

if [[ ! -e "$MA_BIN_PATH/dataconnectionmanager" ]]; then
  echo "no binary files found in $MA_BIN_PATH"
else
    echo "removing binary files from $MA_BIN_PATH"
    rm -f $MA_BIN_PATH/dataconnectionmanager
fi

sync
sync
sync

echo "Done. Reboot the unit"
