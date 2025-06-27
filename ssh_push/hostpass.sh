function vm_host(){
read -p "Enter how many vm's you have" vm
#checking if vm greater than zero or not
if [[ "$vm" -gt 0 ]]; then 
    #creating host_vars "-p" flag makesure if the file exist then no creation
    mkdir -p /mnt/c/Users/gurra/Downloads/ssh_push/host_vars
    #switching to the dir created now
    cd /mnt/c/Users/gurra/Downloads/ssh_push/host_vars || exit
    #for-loop if vm input is 50 then it will run till the 50-51>=50
    for (( i=1; i <= vm; i++ )); do
        #ipaddress, username, and password input
        read -p "enter ip address" ipaddr
        read -p "Enter username" username
        read -s -p "Enter password" password
        #to stop overlapping
        echo ""
        #checking if any of the input is not empty
        if [[ -n "$ipaddr" && -n "$username" && -n "$password" ]]; then
            #appending the data into ipaddr.yml file
            echo "ansible_user: "${username}" ansible_password: "${password}"" >> "${ipaddr}".yml 
            echo "saved ${ipaddr}.yml in host_vars"
        else
            echo "Enter username and password please"
        fi
    done
else
    echo "Enter some numbers"
fi
}
#function to run
vm_host