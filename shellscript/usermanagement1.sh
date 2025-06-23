#!/bin/bash

LOG_DIR="~/Downloads"
LOG_FILE="$LOG_DIR/userscript.log"

mkdir -p "$LOG_DIR"

function log(){
    echo "[$(date "+%Y-%m-%d %H:%M:%S")] $1" >> "$LOG_FILE" >/dev/null
}

if [[ $UID -ne 0 ]]; then
    echo "be a root user before running the script"
    exit 1
fi

function usercreate(){
    read -p "Enter user to create" user
    if id $user &>/dev/null; then
        echo "user already exist"
        log "Attempted to create user '$user' but it already exists."
    else
        echo "user creating"
        #if [[ $UID -eq 0 ]]; then
            read -p "wanna add or create group same same as user? (Y/n)" option
            if [[ $option = "Y" || $option = "y" ]]; then
                read -p "Enter existing group name" groupn
                sudo useradd -g "$groupn" -s /bin/bash -c "creating newuser" -m -d /home/"$user" "$user"
                sudo passwd "$user"
                log "User '$user' created and added to existing group '$groupn'."
            else
                read -p "want to create same group as username(Y) or different(n)?" option1
                if [[ $option1 = "Y" || $option1 = "y" ]]; then
                    sudo groupadd "$user"
                    sudo useradd -g "$user" -s /bin/bash -c "creating newuser" -m -d /home/"$user" "$user"
                    sudo passwd "$user"
                    log "User '$user' and group '$user' created successfully."
                else
                    read -p "enter groupname" groupn1
                    sudo groupadd "$groupn1"
                    sudo useradd -g "$groupn1" -s /bin/bash -c "creating newuser" -m -d /home/"$user" "$user"
                    sudo passwd "$user"
                    log "User '$user' is created and assigned to new group '$groupn1' created successfully."
                fi
            fi 
        #else
        #echo "not a root user"
        #fi
    fi
}

function listuser(){
    read -p "print all user(Y) or specific userdetail(n)" option2
    if [[ $option2 = "Y" || $option2 = "y" ]]; then
        cat /etc/passwd
        log "Listed all users."
    else
        read -p "enter username" user1
        cat /etc/passwd | grep -w "$user1"
        log "Listed specific user : '$user1'."
    fi
}

function groupchange(){
    read -p "want to change primary group(Y) or add in different group by staying in primary group(n)" option3
    if [[ $option3 = "Y" || $option3 = "y" ]]; then
        read -p "Enter username" user2
        read -p "Enter groupname" groupn2
        sudo usermod -g "$groupn2" "$user2"
        log "Change the primary group '$groupn2 of this user '$user2'."
    else
        read -p "Enter username" user3
        read -p "Enter groupname" groupn3
        sudo usermod -aG "$groupn3" "$user3"
        log "Adding to the secondary group '$groupn3 of this user '$user3'."
    fi
}

function ownership_change(){
    read -p "username:username (Y) or username:groupname (n)" option4
    if [[ $option4 = "Y" || $option4 = "y" ]]; then
        read -p "Enter username" user4
        read -p "Enter path for the file(/path/to/file)" path
        sudo chown "$user4":"$user4" "$path"
        log "ownership change of this '$path' to '$user4":"$user4'."
    else
        read -p "Enter username" user5
        read -p "Enter groupname" groupn5
        read -p "Enter path for the file(/path/to/file)" path1
        sudo chown "$user5":"$groupn5" "$path1"
        log "ownership change of this '$path' to '$user5":"$groupn5'."
    fi
}

function username_change(){
    read -p "Enter old username" oldusername
    read -p "Enter new username" newusername
    sudo usermod -l "$newusername" "$oldusername"
    log "Username change '$oldusername' To '$newusername'."
}

function lock_unlock(){
    read -p "lock (Y) and unlock (n)" lockunlock
    read -p "Enter username" user6
    if [[ $lockunlock = "Y" || $lockunlock = "y" ]]; then
        sudo usermod -L "$user6"
        log "Locking the user '$user6'."
    else
        sudo usermod -U "$user6"
        log "Unlocking the user '$user6'."
    fi
}

case $1 in 
    --usercreate)
        usercreate
    ;;
    --listuser)
        listuser
    ;;
    --changegroup)
        groupchange
    ;;
    --ownershipchange)
        ownership_change
    ;;
    --usernamechange)
        username_change
    ;;
    --lockunlock)
        lock_unlock
    ;;
    *)
        echo -e "\n To create user the parameter (--usercreate)"
        echo -e "\n To list users the parameter (--listuser)"
        echo -e "\n To change group the parameter (--changegroup)"
        echo -e "\n To change file ownership the parameter (--ownershipchange)"
        echo -e "\n To change username the parameter (--usernamechange)"
        echo -e "\n To lock/unlock user the parameter (--lockunlock)"
        log "Invalid parameter or no option provided"
    ;;
esac