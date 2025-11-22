#!/bin/bash

# --- Configuration ---
SERVER_LIST_FILE="servers.txt"
OUTPUT_DIR="ping_results"
PINGING_SERVERS_FILE="$OUTPUT_DIR/servers_pinging.txt"
NOT_PINGING_SERVERS_FILE="$OUTPUT_DIR/servers_not_pinging.txt"
PING_COUNT=3
PING_TIMEOUT=1

# --- Setup ---
mkdir -p "$OUTPUT_DIR"
> "$PINGING_SERVERS_FILE"
> "$NOT_PINGING_SERVERS_FILE"

echo "--- ping check starting ---"
echo " "

# Read each server from the list file
while IFS= read -r server; do

    # Ping the server
    ping -c "$PING_COUNT" -W "$PING_TIMEOUT" "$server" > /dev/null 2>&1

    # Check the exit status of the ping command
    if [ $? -eq 0 ]; then
        #echo -e "  \e[32m$server is PINGING.\e[0m"
        echo "$server" >> "$PINGING_SERVERS_FILE"
    else
        #echo -e "  \e[31m$server is NOT PINGING.\e[0m"
        echo "$server" >> "$NOT_PINGING_SERVERS_FILE"
    fi
    #echo "----------------------------------" # Separator for each server's check
done < "$SERVER_LIST_FILE"

#echo "  Servers PINGING: $(wc -l < "$PINGING_SERVERS_FILE") found. See '$PINGING_SERVERS_FILE'"
#echo "  Servers NOT PINGING: $(wc -l < "$NOT_PINGING_SERVERS_FILE") found. See '$NOT_PINGING_SERVERS_FILE'"

echo " "
echo "--- ping check finished ---"
