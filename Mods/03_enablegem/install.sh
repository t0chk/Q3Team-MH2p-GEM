#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk https://t.me/q3f3chat

echo "Starting of [enablegem] script..."

# Функция для проверки, является ли файл ELF-бинарным
is_elf_binary() {
    local file=$1
    # Проверяем, что файл существует
    if [[ ! -f "$file" ]]; then
        echo "[ELFB] File does not exist: $file"
        return 1  # Файл не существует
    fi

    # Читаем байты 2, 3 и 4 файла (пропуская первый байт)
    elf_check=$(dd if="$file" bs=1 skip=1 count=3 2>/dev/null)
    # Если файл меньше 4 байт, dd вернет пустую строку
    if [[ -z "$elf_check" ]]; then
        echo "[ELFB] File is too small: $file"
        return 1  # Файл слишком мал
    fi

    # Проверяем, совпадают ли байты 2, 3 и 4 с ELF
    if [[ "$elf_check" == "ELF" ]]; then
        echo "[ELFB] File $file is an ELF binary file"
        return 0
    else
        echo "[ELFB] File $file is not an ELF binary file"
        return 1
    fi
}

if [[ -e /fs/sda0 ]]; then
	modPath=/fs/sda0
	echo "Use SD1 card as source"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	modPath=/fs/sdb0
	echo "Use SD2 card as source"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	modPath=/fs/usb0_0
	echo "Use USB1 drive as source"
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi

if [[ ! -e "$modPath/Storage/enablegem/servicemgrmibhigh" ]]; then
	echo "[ERR] servicemgrmibhigh not found in [$modPath]"
	exit 1
fi

# Проверка наличия папки backup
[[ ! -e $modPath/backup ]] && mkdir $modPath/backup
[[ ! -e $modPath/backup ]] && echo "Error: cannot create $modPath/backup folder!" && exit 1

# Монтирование точек
[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app as dest..."
mount -uw /mnt/app

[[ ! -e "/mnt/ota" ]] &&  mount -t qnx6 /dev/mnanda0t177.16 /mnt/ota
echo "Mounting /mnt/ota as dest..."
mount -uw /mnt/ota

echo "Mounting /mnt/swup in r/w mode..."
[[ ! -e "/mnt/swup" ]] && mount -t qnx6 /dev/mnanda0t177.2 /mnt/swup
mount -uw /mnt/swup/

echo "Mounting /mnt/persist_new in r/w mode..."
[[ ! -e "/mnt/persist_new" ]] && mount -t qnx6 /dev/mnanda0t177.5 /mnt/persist_new
mount -uw /mnt/persist_new

# Основная логика установки патча
if is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh"; then
    # Кейс 1: servicemgrmibhigh — бинарный файл (чистая система)
    echo "Clean system detected. Installing patch..."
    echo "Copied new servicemgrmibhigh from [$modPath]"
    cp -fV "/mnt/app/eso/bin/servicemgrmibhigh" "/mnt/app/eso/bin/servicemgrmibhigh99"
    if [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]]; then
        echo "[ERR] servicemgrmibhigh99 not found after cp. Aborting."
        exit 1
    fi
    cp -fV "$modPath/Storage/enablegem/servicemgrmibhigh" "/mnt/app/eso/bin/"
    chmod 755 "/mnt/app/eso/bin/servicemgrmibhigh"

else
    # Кейс 2: servicemgrmibhigh — не бинарный файл (патч уже установлен)
    if is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh0"; then
        # Подкейс 2.1: servicemgrmibhigh0 — бинарный (старый патч)
        echo "[Toolbox] patch detected ([servicemgrmibhigh0] is a binary file)."
        cp -fV "/mnt/app/eso/bin/servicemgrmibhigh0" "/mnt/app/eso/bin/servicemgrmibhigh99"
        if [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]]; then
            echo "[ERR] servicemgrmibhigh99 not found after cp. Aborting."
            exit 1
        fi
        cp -fV "$modPath/Storage/enablegem/servicemgrmibhigh" "/mnt/app/eso/bin/"
        chmod 755 "/mnt/app/eso/bin/servicemgrmibhigh"
    elif is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh99"; then
        # Подкейс 2.2: servicemgrmibhigh99 — бинарный (новый патч)
        echo "[Q3Team] patch detected ([servicemgrmibhigh99] is a binary file)."
        cp -fV "$modPath/Storage/enablegem/servicemgrmibhigh" "/mnt/app/eso/bin/"
        chmod 755 "/mnt/app/eso/bin/servicemgrmibhigh"
    else
        # Подкейс 2.3: ни servicemgrmibhigh0, ни servicemgrmibhigh99 не являются бинарными
        echo "[ERR] Unknown patch state. Aborting."
        exit 1
    fi
fi

# Копирование FEC
echo "Backup fecmanager..."
[[ -e /mnt/app/eso/bin/apps/fecmanager ]] && cp -fV /mnt/app/eso/bin/apps/fecmanager $modPath/backup/

#1 Скопировать fecmanager в /mnt/app/eso/bin/apps/ с заменой
echo "Replacing /mnt/app/eso/bin/apps/fecmanager"
cp -fV $modPath/Storage/installfecs/fecmanager /mnt/app/eso/bin/apps/fecmanager
chmod 755 /mnt/app/eso/bin/apps/fecmanager

#2 Скопировать fecmanager в /mnt/swup/eso/bin/apps/ с заменой
echo "Replacing /mnt/swup/eso/bin/apps/fecmanager"
cp -Vf $modPath/Storage/installfecs/fecmanager /mnt/swup/eso/bin/apps/fecmanager
chmod 755 /mnt/swup/eso/bin/apps/fecmanager

#3 Скопирповать ExceptionList.txt в /mnt/persist_new/fec/ExceptionList.txt с заменой
echo "Copy /mnt/persist_new/fec/ExceptionList.txt"
cp -Vf $modPath/Storage/installfecs/ExceptionList.txt /mnt/persist_new/fec/ExceptionList.txt

#4 FoD=SwaP
echo "Script set FoD=SwaP flag by [enablegem] mod"

# Копирование дополнительных файлов
echo "Copying additional files..."

cp -fV $modPath/Storage/enablegem/challenge.pub /mnt/ota/
cp -fv $modPath/Storage/enablegem/doas.conf /mnt/ota/
cp -fV /mnt/app/eso/bin/servicemgrmibhigh99 /mnt/ota/servicemgrmibhigh
cp -fRV $modPath/Storage/gemfiles/. /mnt/app/eso/hmi/engdefs

chmod 755 /mnt/app/eso/hmi/engdefs/scripts/*
chmod 444 /mnt/ota/doas.conf

sync
sync

echo "Done."

