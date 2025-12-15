#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t coding nochina] script..."

[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new
echo "Mounting /mnt/persist_new in r/w mode..."
mount -uw /mnt/persist_new

[[ ! -e "/mnt/persist_new/coding_no_china" ]] && touch /mnt/persist_new/coding_no_china

sync
sync

echo "Done."