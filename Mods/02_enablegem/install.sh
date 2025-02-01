#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

# Функция для проверки, является ли файл ELF-бинарным
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

echo "Starting installation of q3team patch..."

if [[ -e /fs/sda0 ]]; then
	srcPath=/fs/sda0
	echo "Use SD1 card as source"
elif [[ -e /fs/sdb0 ]]; then
	mount -uw /fs/sdb0
	srcPath=/fs/sdb0
	echo "Use SD2 card as source"
elif [[ -e /fs/usb0_0 ]]; then
	mount -uw /fs/usb0_0
	srcPath=/fs/usb0_0
	echo "Use USB1 drive as source"
else
	echo "[ERR] cannot find any SD card/USB drive!"
	exit 1
fi

if [[ ! -e "$srcPath/Storage/01/servicemgrmibhigh" ]]; then
	echo "[ERR] servicemgrmibhigh not found in [$srcPath]"
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app as dest..."
mount -uw /mnt/app

[[ ! -e "/mnt/ota" ]] &&  mount -t qnx6 /dev/mnanda0t177.16 /mnt/ota
echo "Mounting /mnt/ota as dest..."
mount -uw /mnt/ota

# Основная логика
if is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh"; then
    # Кейс 1: servicemgrmibhigh — бинарный файл (чистая система)
    echo "Clean system detected. Installing patch..."
    echo "Copied new servicemgrmibhigh from [$srcPath]"
    cp -f "/mnt/app/eso/bin/servicemgrmibhigh" "/mnt/app/eso/bin/servicemgrmibhigh99"
    if [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]]; then
        echo "[ERR] servicemgrmibhigh99 not found after cp. Aborting."
        exit 1
    fi
    cp -f "$srcPath/Storage/01/servicemgrmibhigh" "/mnt/app/eso/bin/"

else
    # Кейс 2: servicemgrmibhigh — не бинарный файл (патч уже установлен)
    if is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh0"; then
        # Подкейс 2.1: servicemgrmibhigh0 — бинарный (старый патч)
        echo "[Toolbox] patch detected ([servicemgrmibhigh0] is a binary file)."
        cp -f "/mnt/app/eso/bin/servicemgrmibhigh0" "/mnt/app/eso/bin/servicemgrmibhigh99"
        if [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]]; then
            echo "[ERR] servicemgrmibhigh99 not found after cp. Aborting."
            exit 1
        fi
        cp -f "$srcPath/Storage/01/servicemgrmibhigh" "/mnt/app/eso/bin/"
    elif is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh99"; then
        # Подкейс 2.2: servicemgrmibhigh99 — бинарный (новый патч)
        echo "[Q3Team] patch detected ([servicemgrmibhigh99] is a binary file)."
        cp -f "$srcPath/Storage/01/servicemgrmibhigh" "/mnt/app/eso/bin/"
    else
        # Подкейс 2.3: ни servicemgrmibhigh0, ни servicemgrmibhigh99 не являются бинарными
        echo "[ERR] Unknown patch state. Aborting."
        exit 1
    fi
fi

# Копирование дополнительных файлов
echo "Copying additional files..."

cp -f $srcPath/Storage/01/challenge.pub /mnt/ota/
cp -f $srcPath/Storage/02/doas.conf /mnt/ota/
cp -f /mnt/app/eso/bin/servicemgrmibhigh99 /mnt/ota/servicemgrmibhigh

# Работа с remgem
# Ищем файл, начинающийся с "arc.remgem_"
search_path="/mnt/app/eso/bundles"
remgem_path=$(find "$search_path" -type f -name "arc.remgem_*" 2>/dev/null)

# Проверяем, найден ли файл
if [[ -n "$remgem_path" ]]; then
    echo "found remgem: $remgem_path"
    # Копируем файл из 02 в найденный путь
    cp -f "$srcPath/Storage/02/arc.remgem.jar" "$remgem_path"
else
    echo "[ERR] remgem not found in $search_path"
fi

# Завершение работы
echo "Unmounting /mnt/app..."
sync
[[ -e "/mnt/app" ]] && umount -f /mnt/app

echo "Done."

