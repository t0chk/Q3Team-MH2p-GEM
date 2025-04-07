#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

# add paths to the LD_LIBRARY_PATH
function extend_ld_library_path
{
    while [ $# -gt 0 ]; do
        if [ -n "$1" ]; then
            if [ -n "${LD_LIBRARY_PATH}" ]; then
                export LD_LIBRARY_PATH="$LD_LIBRARY_PATH":"$1"
            else
                export LD_LIBRARY_PATH="$1"
            fi
        fi
        shift
    done
}

echo "Starting of [langs] script..."

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app

# echo "Mounting /mnt/app in r/w mode..."
# mount -uw /mnt/app

echo "Apply language strings..."

# System Language
pc b:0x31C0136:0xCA "72 75 5F 52 55 00 72 75 5F 52 55 00 72 75 5F 52  55 00 53 30 1B 42"

# Visible Languages
pc b:0x31C0136:0xC9 "18 63 73 5F 43 5A 01 6E 6C 5F 4E 4C 01 65 6E 5F 47 42 01 66 72 5F 46 52 01 64 65 5F 44 45 01 69 74 5F 49 54 01 70 6C 5F 50 4C 01 70 74 5F 50 54 01 72 75 5F 52 55 01 65 73 5F 45 53 01 73 76 5F 53 45 01 74 72 5F 54 52 02 6E 6F 5F 4E 4F 01 68 75 5F 48 55 01 64 61 5F 44 4B 01 66 69 5F 46 49 01 65 6C 5F 47 52 01 68 72 5F 48 52 01 73 6C 5F 53 49 01 73 6B 5F 53 4B 01 72 6F 5F 52 4F 01 73 72 5F 52 53 01 62 73 5F 42 41 01 75 6B 5F 55 41 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 41 31 25 5D"

# re-read data
echo "Check data..."
echo "CA (0x280)"

pc b:0x31C0136:0xCA

echo "C9 (0x2D00)"
pc b:0x31C0136:0xC9

sync
sync
sync

echo "Done. Reboot the unit."