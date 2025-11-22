#!/bin/bash

hostname_file="servers.txt"
OUTPUT_DIR="/tmp/health_check"

mkdir -p "$OUTPUT_DIR"

echo "Starting remote health checks..."
echo "Output will be saved to '$OUTPUT_DIR/info-<hostname_or_ip>'"
echo "--------------------------------------------------"

for i in $(cat "$hostname_file")
do
    echo "Processing host: $i"
    # Define a unique output file for each host
    host_output_file="$OUTPUT_DIR/info-$i"

    ssh root@"$i" /bin/bash << 'EOF_REMOTE_COMMANDS' > "$host_output_file" 2>&1

        echo "--- Remote Host: $(hostname -f) ---"
        echo "--- Timestamp: $(date) ---"
        echo " "

        echo "===hostname info==="
        hostname -f
        echo " "

        echo "===uptime==="
        uptime
        echo " "

        echo "===df -Th ==="
        df -Th
        echo " "

        echo "===findmnt --df==="
        findmnt --df
        echo " "

        echo "===fstab info==="
        cat /etc/fstab
        echo " "

        echo "===lsblk info==="
        lsblk -f
        echo " "

        echo "--- End of Remote Commands ---"
EOF_REMOTE_COMMANDS

    # Check the exit status of the SSH command *after* the here-document
    if [ $? -ne 0 ]; then
        echo -e "\e[31mError: SSH connection or remote command execution failed for $i. Check '$host_output_file'\e[0m"
    else
        echo -e "\e[32mSuccessfully collected info from $i. Output in '$host_output_file'.\e[0m"
    fi
    echo "--------------------------------------------------"
    echo " " # Add a blank line for better readability between hosts

done

echo "=====Script finished====="
