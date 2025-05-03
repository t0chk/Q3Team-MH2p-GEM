#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [check_coding] script..."

echo "Mounting /mnt/app in r/w mode..."
[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

echo "Variant: $(/mnt/app/armle/usr/bin/pc s:678364556:12 2>/dev/null)"
echo "SW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF187 | awk '{print $13}' 2>/dev/null) HW: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0xF191 | awk '{print $13}' 2>/dev/null)"
echo "5F coding: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x600 | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)"
echo "5F adaptations: $(/mnt/app/armle/usr/bin/pc b:0x5F22:0x22AD | awk -F "  " '{ORS="";gsub(/ /,"",$2);print $2}' 2>/dev/null)"