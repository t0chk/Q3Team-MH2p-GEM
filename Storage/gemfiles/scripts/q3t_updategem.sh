#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t gem update] script..."

. /eso/hmi/engdefs/scripts/q3t_common.sh 

GEMPATH=/mnt/app/eso/hmi/engdefs
BINPATH=/mnt/app/armle/usr/bin

mount_device
ensure_mnt_app_rw
check_device

if [[ ! -e "$MODPATH/Storage/enablegem/doas.conf" ]]; then
	echo "[ERR] doas.conf not found in [$MODPATH]/Storage/enablegem"
	exit 1
fi

echo "Remove old GEM files..."
rm -f $GEMPATH/0x600_longcoding.esd
rm -f $GEMPATH/q3*.esd
rm -rf $GEMPATH/scripts/q3*.sh
rm -rf /mnt/ota/gem_jars/*

echo "Copy & fix doas.conf..."
cp -fv $MODPATH/Storage/enablegem/doas.conf /mnt/ota/
chmod 444 /mnt/ota/doas.conf

echo "Copying new GEM files..."
cp -fRV $MODPATH/Storage/gemfiles/. $GEMPATH
chmod 755 $GEMPATH/scripts/*

[[ ! -e /mnt/ota/gem_jars ]] && mkdir /mnt/ota/gem_jars

echo "Remove old JAR files..."
rm -f /mnt/ota/gem_jars/*

echo "Copying new JAR files..."
cp -fRV $MODPATH/Storage/jars/. /mnt/ota/gem_jars

echo "Copying bin files..."
chmod 755 $MODPATH/Storage/bin/*
cp -fRV $MODPATH/Storage/bin/. $BINPATH

sync
sync
sync

echo "Done. Reboot the unit."