#!/bin/sh

GEM_JARS_PATH=/mnt/ota/gem_jars
LSD_JARS_PATH=/mnt/app/eso/hmi/lsd/jars

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

if [[ ! -e "$LSD_JARS_PATH/NaviCompass.jar" ]]; then
	echo "Disabling compass"
    cp -Vf $GEM_JARS_PATH/NaviCompass.jar $LSD_JARS_PATH/NaviCompass.jar
else
    echo "Enabling compass"
    rm -f $LSD_JARS_PATH/NaviCompass.jar
fi

sync
sync
sync

echo "Done. Reboot the unit."