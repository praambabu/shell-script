#!/bin/bash
PING_COUNT=3
PING_TIMEOUT=1

read -p "Enter Adhoc command: " command

if [ -z "$command" ]; then
    echo "Error: Input cannot be empty. Exiting."
    exit 1
fi

for i in $(cat /root/shell-script/servers.txt)
do
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$i" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo $i 
        echo -e "\e[31m `ssh $i $command`\e[0m"
    else
        echo $i
        echo -e "\e[31mError: SSH connection issue or remote server not pingging.\e[0m"
        
    fi
done
