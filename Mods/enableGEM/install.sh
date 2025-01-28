#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app in r/w mode..."
mount -uw /mnt/app

/mnt/app/armle/usr/bin/pc b:0x5F22:0x243F:0.7 1 

echo "enable GEM [OK]"
sync
[[ -e "/mnt/app" ]] && umount -f /mnt/app