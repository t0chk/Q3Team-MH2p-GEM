#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [enableudefupdate] script..."

[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new
echo "Mounting /mnt/persist_new in r/w mode..."
mount -uw /mnt/persist_new

[[ ! -e "/mnt/persist_new/swup/allowUserDefinedUpdate" ]] && touch /mnt/persist_new/swup/allowUserDefinedUpdate
[[ ! -e "/mnt/persist_new/swup/checkAllUpdatesPROD" ]] && touch /mnt/persist_new/swup/checkAllUpdatesPROD
[[ ! -e "/mnt/persist_new/swup/skipCheckInstallerChecksumPROD" ]] && touch /mnt/persist_new/swup/skipCheckInstallerChecksumPROD
[[ ! -e "/mnt/persist_new/swup/skipCheckMetaChecksumPROD" ]] && touch /mnt/persist_new/swup/skipCheckMetaChecksumPROD
[[ ! -e "/mnt/persist_new/swup/skipCheckVariantPROD" ]] && touch /mnt/persist_new/swup/skipCheckVariantPROD

sync
sync

echo "Done."