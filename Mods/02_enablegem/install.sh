#!/bin/ksh
# Copyright (c) 2025 https://t.me/tochk

# Функция для проверки, является ли файл ELF-бинарным
is_elf_binary() {
    local file=$1
    # Читаем первые 4 байта файла
    first_bytes=$(dd if="$file" bs=4 count=1 2>/dev/null)
    # Преобразуем байты в шестнадцатеричный формат
    hex_bytes=$(printf "%02x%02x%02x%02x" "'${first_bytes:0:1}" "'${first_bytes:1:1}" "'${first_bytes:2:1}" "'${first_bytes:3:1}")
    # Проверяем, совпадают ли первые байты с ELF-магическим числом
    [[ $hex_bytes == "7f454c46" ]]
}

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
	echo "Error: cannot find any SD card/USB drive!"
	exit 1
fi

if [[ ! -e "$srcPath/Storage/01/servicemgrmibhigh" ]]; then
	echo "Error: servicemgrmibhigh not found in [SRC]."
	exit 1
fi

[[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
echo "Mounting /mnt/app as dest..."
mount -uw /mnt/app

[[ ! -e "/mnt/ota" ]] &&  mount -t qnx6 /dev/mnanda0t177.16 /mnt/ota
echo "Mounting /mnt/ota as dest..."
mount -uw /mnt/ota


# Основная логика
case true in
    # Кейс 1: servicemgrmibhigh0 отсутствует, но есть servicemgrmibhigh99
    $([[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh0" ]] && [[ -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]]))
        if is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh99"; then
            echo "Patch already installed. servicemgrmibhigh99 is a binary file. Updating servicemgrmibhigh from srcPath..."
            cp -f "$srcPath/Storage/01/servicemgrmibhigh" "/mnt/app/eso/bin/"
            chmod 755 "/mnt/app/eso/bin/servicemgrmibhigh"
            echo "Copied new servicemgrmibhigh from [SRC]"
        else
            echo "ERROR: servicemgrmibhigh99 is not a binary file. Aborting."
            exit 1
        fi
        ;;

    # Кейс 2: servicemgrmibhigh0 отсутствует, servicemgrmibhigh99 отсутствует, servicemgrmibhigh НЕ бинарный
    $([[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh0" ]] && [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]] && ! is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh"))
        echo "ERROR: servicemgrmibhigh is not a binary file, and no backup found. Aborting."
        exit 1
        ;;

    # Кейс 3: servicemgrmibhigh0 присутствует и бинарный, servicemgrmibhigh текстовый
    $([[ -e "/mnt/app/eso/bin/servicemgrmibhigh0" ]] && is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh0" && ! is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh"))
        echo "Third-party patch detected. Renaming servicemgrmibhigh0 to servicemgrmibhigh99..."
        cp -f "/mnt/app/eso/bin/servicemgrmibhigh0" "/mnt/app/eso/bin/servicemgrmibhigh99"
        cp -f "$srcPath/Storage/01/servicemgrmibhigh" "/mnt/app/eso/bin/"
        chmod 755 "/mnt/app/eso/bin/servicemgrmibhigh"
        echo "Copied new servicemgrmibhigh from [SRC]"
        ;;

    # Кейс 4: servicemgrmibhigh0 отсутствует, servicemgrmibhigh99 отсутствует, servicemgrmibhigh бинарный
    $([[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh0" ]] && [[ ! -e "/mnt/app/eso/bin/servicemgrmibhigh99" ]] && is_elf_binary "/mnt/app/eso/bin/servicemgrmibhigh"))
        echo "Clean system detected. Installing patch..."
		cp -f "/mnt/app/eso/bin/servicemgrmibhigh" "/mnt/app/eso/bin/servicemgrmibhigh99"
        cp -f "$srcPath/Storage/01/servicemgrmibhigh" "/mnt/app/eso/bin/"
        chmod 755 "/mnt/app/eso/bin/servicemgrmibhigh"
        echo "Copied new servicemgrmibhigh from [SRC]"
        ;;

    # Кейс 5: Неожиданная ситуация
    *)
        echo "ERROR: Unexpected state. Aborting."
        exit 1
        ;;
esac

cp -f $srcPath/Storage/01/challenge.pub /mnt/ota/
cp -f $srcPath/Storage/01/doas.conf /mnt/ota/
cp -f /mnt/app/eso/bin/servicemgrmibhigh99 /mnt/ota/servicemgrmibhigh

echo "Unmounting /mnt/app..."
sync
[[ -e "/mnt/app" ]] && umount -f /mnt/app

