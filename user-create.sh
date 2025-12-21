#!/bin/bash

# --- Configuration ---
list="servers.txt"
new_dir="/tmp/99"
up="$new_dir/servers_up.txt"
not_up="$new_dir/servers_not_up.txt"
PING_COUNT=3
PING_TIMEOUT=1

# --- Setup ---
mkdir -p "$new_dir"
> "$up"
> "$not_up"

# Check if servers.txt exists
if [[ ! -f "$list" ]]; then
    echo "Error: $list not found!"
    exit 1
fi

# Get Username
read -p "Enter the username to check/create: " user_name

if [[ -z "$user_name" ]]; then
    echo "Error: Username cannot be empty. Exiting."
    exit 1
fi

# Read each server from the list file
while IFS= read -r server; do
     
    # Skip empty lines or comments
    [[ -z "$server" || "$server" =~ ^# ]] && continue

    # Ping the server
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$server" > /dev/null 2>&1

    if [ $? -eq 0 ]; then
        echo "Processing host: $server"
        
        ssh root@"$server" /bin/bash << EOF_REMOTE_COMMANDS >> "$up" 2>&1
        
        hostname -f
        id "$user_name" > /dev/null 2>&1

        # We use \$? so the REMOTE server checks the status
        if [ \$? -eq 0 ]; then
            echo "ID available"
            id "$user_name"
        else
            echo "New ID created"   
            useradd "$user_name"
            id "$user_name"
        fi
        echo " "

EOF_REMOTE_COMMANDS

    else
        echo "Processing host: $server"
        echo "$server" >> "$not_up"
    fi

done < "$list"

echo "Info available at: $new_dir"
echo " "
echo "--- ping check finished ---"
