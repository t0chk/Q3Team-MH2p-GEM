mount_device() {
    if [[ -e /fs/sda0 ]]; then
        MODPATH=/fs/sda0
        echo "Using SD1..."
    elif [[ -e /fs/sdb0 ]]; then
        mount -uw /fs/sdb0
        MODPATH=/fs/sdb0
        echo "Using SD2..."
    elif [[ -e /fs/usb0_0 ]]; then
        mount -uw /fs/usb0_0
        MODPATH=/fs/usb0_0
        echo "Using USB..."
    else
        echo "[ERR] No device found!"
        exit 1
    fi

    echo
}

ensure_mnt_app_rw() {
    [[ ! -e "/mnt/app" ]] && mount -t qnx6 /dev/mnanda0t177.1 /mnt/app
    echo "Mounting /mnt/app in r/w mode..."
    mount -uw /mnt/app

    echo
}

check_device() { 
    if [[ -z "$MODPATH" || ! -d "$MODPATH" ]]; then
        echo "[ERR] MODPATH not set or device not mounted!"
        exit 1
    fi

    echo "MODPATH is set: $MODPATH"
    echo
}

ensure_backup_dir() {
    if [[ -z "$MODPATH" || ! -d "$MODPATH" ]]; then
        echo "[ERR] MODPATH not set or device not mounted!"
        exit 1
    fi

    BACKUPDIR="$MODPATH/backup"

    echo "Backup directory: $BACKUPDIR"

    [[ ! -e $BACKUPDIR ]] && mkdir "$BACKUPDIR"

    if [[ ! -e $BACKUPDIR ]]; then
        echo "[ERR] cannot create $BACKUPDIR folder!"
        exit 1
    fi

    echo
}