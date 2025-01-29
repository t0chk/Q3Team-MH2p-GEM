#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new
echo "Mounting /mnt/persist_new in r/w mode..."
mount -uw /mnt/persist_new

touch /mnt/persist_new/swup/allowUserDefinedUpdate
touch /mnt/persist_new/swup/checkAllUpdatesPROD
touch /mnt/persist_new/swup/skipCheckInstallerChecksumPROD
touch /mnt/persist_new/swup/skipCheckMetaChecksumPROD
touch /mnt/persist_new/swup/skipCheckVariantPROD

echo "enable user defined update [OK]"
sync
sync