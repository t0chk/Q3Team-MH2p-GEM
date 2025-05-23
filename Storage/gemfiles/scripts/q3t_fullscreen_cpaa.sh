#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

GEM_JARS_PATH=/mnt/ota/gem_jars
LSD_JARS_PATH=/mnt/app/eso/hmi/lsd/jars

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

if [[ ! -e "$LSD_JARS_PATH/FullScreenAACPCL.jar" ]]; then
	echo "Activating FullScreen..."
    cp -Vf $GEM_JARS_PATH/FullScreenAACPCL.jar $LSD_JARS_PATH/FullScreenAACPCL.jar
else
    echo "Disabling previously installed FullScreen mod... Run script again to install back."
    rm -f $LSD_JARS_PATH/FullScreenAACPCL.jar
fi

sync
sync
sync

echo "Done. Reboot the unit or install new skin."