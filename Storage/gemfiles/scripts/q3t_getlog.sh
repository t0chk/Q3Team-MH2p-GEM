#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [q3t get q3tlog] script..."

# Определяем доступное устройство для хранения данных
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

# Монтируем устройство для записи
mount -uw $MODPATH

# Создаем папку q3tlog, если её нет
Q3TDIR=$MODPATH/q3tlog
[[ ! -e $Q3TDIR ]] && mkdir $Q3TDIR
[[ ! -e $Q3TDIR ]] && echo "Error: cannot create $Q3TDIR folder!" && exit 1

# Проверяем наличие файла q3t.log
SOURCE_FILE="/mnt/crashlogs/java/q3t.log"
if [[ -e $SOURCE_FILE ]]; then
    echo "File $SOURCE_FILE found. Preparing to copy..."

    # Определяем имя нового файла
    FILE_BASE="$Q3TDIR/q3t"
    FILE_EXT=".log"
    counter=1

    # Поиск первого доступного номера файла
    while [[ -e "$FILE_BASE$counter$FILE_EXT" ]]; do
        counter=$((counter+1))
    done

    DEST_FILE="$FILE_BASE$counter$FILE_EXT"
    echo "Copying $SOURCE_FILE to $DEST_FILE..."

    # Копируем файл
    cp "$SOURCE_FILE" "$DEST_FILE"
    if [[ $? -eq 0 ]]; then
        echo "File copied successfully to $DEST_FILE."
    else
        echo "[ERR] Failed to copy file!"
        exit 1
    fi
else
    echo "File $SOURCE_FILE not found. Nothing to copy."
fi

echo "Done."