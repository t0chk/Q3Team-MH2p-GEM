#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [change_variant] script..."

if [[ -e /fs/sda0 ]]; then
	mount -uw /fs/sda0
	MODPATH=/fs/sda0
	echo "Mounted SD1 card in r/w mode"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	MODPATH=/fs/sdb0
	echo "Mounted SD2 card in r/w mode"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	MODPATH=/fs/usb0_0
	echo "Mounted USB1 drive in r/w mode"
else
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Mounting /mnt/app in r/w mode..."
echo "Variant before change: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)"

/mnt/app/armle/usr/bin/pc s:678364556:12 M2P-HM-NDL-EU-AU-MQB-AL

echo "Variant after change: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)"
echo "Done. Reboot the unit."