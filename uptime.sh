#!/bin/bash

# --- Configuration ---
list="servers.txt"
new_dir="/tmp/up"
up="$new_dir/servers_up.txt"
not_up="$new_dir/servers_not_up.txt"
PING_COUNT=3
PING_TIMEOUT=1

# --- Setup ---
mkdir -p "$new_dir"
> "$up"
> "$not_up"

echo "--- ping check starting ---"
echo " "

# Read each server from the list file
while IFS= read -r server; do

    # Ping the server
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$server" > /dev/null 2>&1

    if [ $? -eq 0 ]; then

        ssh root@"$server" /bin/bash << 'EOF_REMOTE_COMMANDS' >> "$up" 2>&1
        
        hostname -f
        uptime
        echo " "

EOF_REMOTE_COMMANDS

    else
        echo "$server" >> "$not_up"
    fi

done < "$list"

echo "Info available at: $new_dir"
echo " "
echo "--- ping check finished ---"
