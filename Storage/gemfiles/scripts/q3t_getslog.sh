#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t getslog] script..."

if [[ -e /fs/sda0 ]]; then
	MODPATH=/fs/sda0
	echo "Use SD1 card as dest"
elif [[ -e /fs/sdb0 ]]; then
	MODPATH=/fs/sdb0
	echo "Use SD2 card as dest"
elif [[ -e /fs/usb0_0 ]]; then
	MODPATH=/fs/usb0_0
	echo "Use USB1 drive as dest"
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi

mount -uw $MODPATH
SLOGSDIR=$MODPATH/slog
[[ ! -e $SLOGSDIR ]] && mkdir $SLOGSDIR
[[ ! -e $SLOGSDIR ]] && echo "Error: cannot create $SLOGSDIR folder!" && exit 1


# Устанавливаем базовое имя файла и расширение
FILE_BASE="$SLOGSDIR/sloginfo"
FILE_EXT=".log"
FILE_NAME="$FILE_BASE$FILE_EXT"

# Проверяем существование файла sloginfo.log
if [[ -e $FILE_NAME ]]; then
    echo "file $FILE_NAME is exist"
    # Поиск первого доступного номера файла
    counter=1
    while [[ -e "$FILE_BASE$counter$FILE_EXT" ]]; do
        counter=$((counter+1))
    done
    FILE_NAME="$FILE_BASE$counter$FILE_EXT"
    echo "Log in to: $FILE_NAME"
else
    echo "Log in to: $FILE_NAME"
fi

# Создаем лог-файл с нужным именем
sloginfo > $FILE_NAME
echo "Done."