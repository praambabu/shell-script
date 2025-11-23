#!/bin/bash

hostname_file="servers.txt"
new_dir="/tmp/reboot"
reboot_info="$new_dir/servers_info"
no_ping="$new_dir/no_ping_servers.txt"
PING_COUNT=3
PING_TIMEOUT=1

# --- Setup ---
mkdir -p "$new_dir"
> "$reboot_info"
> "$no_ping"

echo "Rebooting remote servers..."
echo " "

for i in $(cat "$hostname_file")
do
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$i" > /dev/null 2>&1

    if [ $? -eq 0 ]; then

    echo "Processing host: $i"

    ssh root@"$i" /bin/bash << 'EOF_REMOTE_COMMANDS' >> "$reboot_info" 2>&1
        hostname -f
        shutdown -Fr now
EOF_REMOTE_COMMANDS

    else
        echo -e "\e[31mError: SSH connection or remote command execution failed for $i.\e[0m"
        echo "$i" >> "$no_ping"
    fi
done
echo "=====Script finished====="
