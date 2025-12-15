#!/bin/ksh

# Целевая директория
TARGET_DIR="/dev"

# Директория для сохранения результатов
OUTPUT_DIR="/fs/sda0/ksh"

mount -uw /fs/sda0

# Создаем директорию для результатов, если её нет
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir "$OUTPUT_DIR"
fi

if [ ! -d "$OUTPUT_DIR" ]; then
    echo "Failed to create output directory: $OUTPUT_DIR"
    exit 1
fi

# Проходим по всем элементам в /dev
for file in $TARGET_DIR/*; do
    # Проверяем, является ли элемент обычным файлом
    if [ -f "$file" ]; then
        # Получаем имя файла без пути
        filename=`echo "$file" | sed 's#.*/##'`
        
        # Создаем путь для выходного файла
        output_file="$OUTPUT_DIR/${filename}.tail"
        
        # Запускаем tail в фоновом режиме
        tail "$file" > "$output_file" 2>/dev/null &
        pid=$!
        
        # Ждем MAX_TIME секунд
        sleep $MAX_TIME
        
        # Проверяем, завершился ли процесс
        if kill -0 $pid 2>/dev/null; then
            # Процесс все еще работает - убиваем его
            kill -9 $pid 2>/dev/null
            echo "Failed to process: $file (timed out)"
        else
            echo "Successfully processed: $file -> $output_file"
        fi
    else
        echo "Skipping: $file (not a regular file)"
    fi
done

echo "Processing complete. Results saved in $OUTPUT_DIR"