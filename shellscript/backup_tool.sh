#!/bin/bash
##########################################
# Author: Tarun Gurram
# INFO: This script must run by root user for taking backups into tar files and deleting old tar files by retention days.
##########################################
if [[ $UID -ne 0 ]]; then
    exit 1
fi


LOG_PATH=/var/log/backup
LOG_FILE="${LOG_PATH}"/backup.log
NAME=$(whoami)

mkdir -p "${LOG_PATH}"

log(){
    echo "[$(date +"%Y-%m-%d_%H-%M-%S")] $1" >> "${LOG_FILE}" >/dev/null
}

taking_backup(){
    read -p "Enter source path" source
    read -p "Enter backup directory" backup

    if [[ -n "${source}" && -n "${backup}" ]]; then
        if [[ ! -d "${source}" ]]; then
            echo "Source not found"
            log "Source directory not found for taking the backup by user: $NAME"
            exit 1
        fi

        mkdir -p "${backup}"

        DATE=$(date +"%Y-%m-%d_%H-%M-%S")
        ARCHIVE_NAME="${NAME}__backup_${DATE}.tar.gz"
    
        echo "creating backup"
        tar -czf "${backup}/${ARCHIVE_NAME}" -C "${source}" . 

        if [[ $? -eq 0 ]]; then
            echo "Successfully taken the backup"
            log "Successfully taken the backup by the user: ${NAME}"
        else
            echo "failed"
            log "Failed to take the backup by the user: ${NAME}"
            exit 1
        fi
    fi
}

deleting_backup(){
    read -p "Enter retention days in numbers" retention
    read -p "Enter backup path to delete them" backup_path

    if ! [[ "${retention}" =~ ^[0-9]+$ ]]; then
        echo "Enter number please"
        log "Entered alphabets instead of numbers in rentention input by user: $NAME"
        exit 1
    else
        if [[ ! -d "${backup_path}" || "${retention}" -eq 0 ]]; then
            echo "Backup folder doesnt exist AND enter retention day more than 0."
            log "Backup folder doesnt exist AND enter retention day more than 0. by user: $NAME"
            exit 1
        else
            find "${backup_path}" -type f -name "*.tar.gz" -mtime +"${retention}" -exec -f rm {} \;
            log "Successfully Deleted old backup files by the user: ${NAME}...Rentention days: $retention"
        fi
    fi
}

case $1 in
    --backup)
        taking_backup
    ;;
    --delete-backup)
        deleting_backup
    ;;
    *)
        echo "Use --backup argument.... for taking backup"
        echo "Use --delete-backup.... to delete the old backup files/folders"
    ;;
esac
