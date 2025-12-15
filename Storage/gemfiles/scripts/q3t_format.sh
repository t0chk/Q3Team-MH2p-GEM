#!/bin/ksh

NAVDB_PARTITION=/mnt/navdb
FS_OPTIONS="$(getfsoptions_from_fstab /mnt/navdb | head -n 1)"
FS_NAME="$(getfsoptions_from_fstab -d /mnt/navdb | head -n 1)"

echo "Cleaning navdb partition, please wait ..."

umount -f $NAVDB_PARTITION

if [[ ! -e $NAVDB_PARTITION ]]; then
    mkqnx6fs $FS_OPTIONS $FS_NAME
else
    echo "ERROR: Unable to unmount /mnt/navdb partition."
    exit 1
fi

mount $NAVDB_PARTITION
/etc/boot/functions/set_permissions.sh -d $NAVDB_PARTITION
rm -rf /mnt/navcache/nds.dm
rm -rf /mnt/navcache/cache
rm -rf /mnt/navcache/ota
rm -rf /mnt/navcache/instant_map
echo "Removing NavDB version file"
rm -rf /mnt/persist_new/swup/filecopy/versions/NavDB.ver
echo "Removing Eggnog version file"
rm -rf /mnt/persist_new/swup/filecopy/versions/Eggnog.ver
echo "Removing HWR version file"
rm -rf /mnt/persist_new/swup/filecopy/versions/HWR.ver
echo "Removing Truffles version file"
rm -rf /mnt/persist_new/swup/filecopy/versions/Truffles.ver
echo "Removing TrufflesSpeech version file"
rm -rf /mnt/persist_new/swup/filecopy/versions/TrufflesSpeech.ver
echo "Removing VDE version file"
rm -rf /mnt/persist_new/swup/filecopy/versions/VDE.ver

sync; sync; sync

sleep 1

echo "Done. please reboot the system now."