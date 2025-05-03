#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [change_variant] script..."

echo "Mounting /mnt/app in r/w mode..."
[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Variant before change: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)"

/mnt/app/armle/usr/bin/pc s:678364556:12 M2P-HM-NDL-EU-AU-MQB-AL

echo "Variant after change: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)"
echo "Done. Reboot the unit."