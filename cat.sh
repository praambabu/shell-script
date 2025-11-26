#!/bin/bash

hostname_file="servers.txt"
OUTPUT_DIR="/tmp/file"
YES="$OUTPUT_DIR/yes"
NO="$OUTPUT_DIR/no"
PING_COUNT=3
PING_TIMEOUT=1

# --- Setup ---
mkdir -p "$OUTPUT_DIR"
> "$YES"
> "$NO"

echo "Output will be saved to '$OUTPUT_DIR/'"
echo "------------------------------------------------"

# --- User Prompt for File Name ---
file_name=""
read -p "Enter the file name (e.g: /etc/fstab): " file_name

if [ -z "$file_name" ]; then
    echo "Error: File path cannot be empty. Exiting."
    exit 1
fi

for i in $(cat "$hostname_file")
do
    echo "Processing host: $i"

    # Ping the server
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$i" > /dev/null 2>&1

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then    

    ssh root@"$i" /bin/bash << EOF_REMOTE_COMMANDS >> "$YES" 2>&1

        echo "===hostname info==="
        hostname -f
        echo " "

        cat "$file_name"

        echo "===== End ====="
        echo " "
EOF_REMOTE_COMMANDS

    else
        echo "$i" >> "$NO"

    fi

done

echo "=====Script finished====="
