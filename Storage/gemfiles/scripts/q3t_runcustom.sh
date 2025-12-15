#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t runcustom] script..."

. /eso/hmi/engdefs/scripts/q3t_common.sh 

CUSTOM=AATest2.jar
CUSTOM2=mh2p-opengl-render
CPPLIB=lib/libcpp.so.5
DSTPATH=/mnt/app/eso

mount_device
ensure_mnt_app_rw

"$MODPATH/custom.sh"

sync
sync

echo "Done."