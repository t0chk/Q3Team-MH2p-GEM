#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

DIAG_PATH=/mnt/persist_new/swup

echo "Starting of [iamsoxorry] script..."

[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new

rm -vf $DIAG_PATH/diagnose.info
touch $DIAG_PATH/diagnose.info

echo "programmingAttempts=10" >> $DIAG_PATH/diagnose.info
echo "randomValue=53044" >> $DIAG_PATH/diagnose.info
echo "testerValue=1766" >> $DIAG_PATH/diagnose.info
echo "reason=" >> $DIAG_PATH/diagnose.info

chmod 666 $DIAG_PATH/diagnose.info

echo "Done. Reboot the unit. Then clear DTC codes."