#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Installation/deinstallation of Q3 configurable RS Performance skin..."

GEM_JARS_PATH=/mnt/ota/gem_jars
LSD_JARS_PATH=/mnt/app/eso/hmi/lsd/jars

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

if [[ ! -e "$LSD_JARS_PATH/CombiSkins.jar" ]]; then
	echo "Adding RS Perfomance skin..."
    cp -Vf $GEM_JARS_PATH/CombiSkinsRsPerfomance.jar $LSD_JARS_PATH/CombiSkins.jar
else
    echo "Disabling RS Performance skin... Run script again to install back."
    rm -f $LSD_JARS_PATH/CombiSkins.jar
fi

sync
sync
sync

echo "Done. Reboot the unit or install new skin."
