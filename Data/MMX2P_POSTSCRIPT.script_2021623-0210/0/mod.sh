#!/bin/ksh
# Copyright (c) 2024 LawPaul (https://github.com/LawPaul)
# This file is part of MH2p_SD_ModKit, licensed under CC BY-NC-SA 4.0.
# https://creativecommons.org/licenses/by-nc-sa/4.0/
# See the LICENSE file in the project root for full license text.
# NOT FOR COMMERCIAL USE

rm -f /mnt/persist_new/dummy.txt

if [[ -e /fs/sda0 ]]; then
    mount -uw /fs/sda0
    export mediaPath=/fs/sda0
elif [[ -e /fs/sdb0 ]]; then
    mount -uw /fs/sdb0
    export mediaPath=/fs/sdb0
elif [[ -e /fs/usb0_0 ]]; then
    mount -uw /fs/usb0_0
    export mediaPath=/fs/usb0_0
else
    exit 1
fi

for dir in $mediaPath/Mods/*
do
    if [ -d "$dir" ]; then
        mod="${dir%/}"
        export modPath=$mod
        export mod="${mod##*/}"
        if [ -f "$dir/install.sh" ]; then
            echo "$(date) ----- Start installing $mod -----" >> $mediaPath/Logs/$mod.log
            ksh "$dir/install.sh" >> $mediaPath/Logs/$mod.log 2>&1
            echo "$(date) ----- Done installing $mod -----" >> $mediaPath/Logs/$mod.log
        elif [ -f "$dir/uninstall.sh" ]; then
            echo "$(date) ----- Start uninstalling $mod -----" >> $mediaPath/Logs/$mod.log
            ksh "$dir/uninstall.sh" >> $mediaPath/Logs/$mod.log 2>&1
            echo "$(date) ----- Done uninstalling $mod -----" >> $mediaPath/Logs/$mod.log
        fi
    fi
done