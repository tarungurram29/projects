#!/bin/bash
#######################################
# Author: Tarun Gurram
# INFO: System performance script runs on a specific time using crontab and alert users via mail
#######################################

set -a
source /home/tarun/.env
set +a

CPU_PERC=80
DISK_PERC=80
MEMORY_PERC=80
USER=$(whoami)

log_file=/var/log/performance/perf.log
mkdir -p /var/log/performance

MPSTAT=$(command -v mpstat | awk -F "/" '{print $4}')
command -v free | awk -F "/" '{print $4}' || { echo "FREE COMMAND NOT FOUND"; exit 1; }
command -v df | awk -F "/" '{print $4}' || { echo "DF COMMAND NOT FOUND"; exit 1; }

log(){
    echo -e "[$(date +"%Y-%m-%d %H:%M:%S")] $1" >> "${log_file}"
}

checking_os(){
    DISTRO=$(cat /etc/os-release | grep -w "NAME" | awk -F "=" '{printf $2}' | tr -d '"')

    case $DISTRO in
        Ubuntu)
            if [[ -z "${MPSTAT}" ]]; then
                echo "Commands not found"
            else
                sudo apt update -y && sudo apt install sysstat -y
            fi
        ;;
        AlmaLinux)
            if [[ -z "${MPSTAT}" ]]; then
                echo "Commands not found"
            else
                echo "Installing commands"
                sudo dnf update -y && sudo dnf install sysstat -y
            fi
        ;;
        *)
            echo "HI KUCHU PUCHU. WHERE IS YOUR PARENTS"
        ;;
    esac
}


send_mail(){

    echo -e "$2" | mail \
    -S smtp="smtp://smtp.gmail.com:587" \
    -S smtp-auth-user="${MAIL_USER}" \
    -S smtp-auth-password="${MAIL_PASS}" \
    -S smtp-auth=login \
    -S smtp-use-starttls \
    -S ssl-verify=ignore \
    -s "$1" \
    -c "${CC_EMAILS}" \
    "${TO_EMAIL}"
}

performance(){
    #################
    # CPU_USAGE
    #################
    CPU=$(mpstat 1 1 | awk '/Average/ {print 100 - $NF}')
    #################
    # MEMORY_USAGE
    #################
    MEMORY=$(free | awk '/Mem/ {printf("%.0f"), $3/$2 * 100}')
    #################
    # DISK_USAGE
    #################
    DISK=$(df / | awk 'NR==2 {print $5}' | tr -d '%')

    if [[ -z "${CPU}" || -z "${MEMORY}" || -z "${DISK}" ]]; then
        exit 1
    fi

    ALERT=""

    if [[ "${CPU}" -gt "${CPU_PERC}" ]]; then
        ALERT+="High CPU Usage: $CPU%\n"
    fi

    if [[ "${DISK}" -gt "${DISK_PERC}" ]]; then
        ALERT+="High DISK Usage: $DISK%\n"
    fi

    if [[ "${MEMORY}" -gt "${MEMORY_PERC}" ]]; then
        ALERT+="High MEMORY Usage: $MEMORY%\n"
    fi

    if [[ -n "${ALERT}" ]]; then
        send_mail "Server Alert!" "$ALERT"
        log " ALERT: $ALERT By the user: $USER"
    else
        log "System healthy"
    fi
}

performance