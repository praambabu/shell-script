#!/bin/bash

# --- Colors ---
BLUE='\033[0;34m'
GREEN='\033[1;32m'
NC='\033[0m'

# --- 1. Gather Data ---
SNAME=$(hostname)
UPTIME=$(uptime -p | sed 's/up //')
SSH_STAT=$(systemctl is-active sshd 2>/dev/null || echo "inactive")


# Detect Hypervisor (KVM, VMware, Oracle, or Physical)
# systemd-detect-virt is the standard way; fallback to 'none' if not found
HYPER=$(systemd-detect-virt 2>/dev/null || echo "physical")

pre=$(echo -e "${GREEN}OK${NC}")

# --- 2. Header Section (Single Row) ---
echo -e "${BLUE}====================================================================================================${NC}"
printf "%-15s | %-15s | %-15s | %-15s | %-15s\n" "SERVERNAME" "UPTIME" "SSHD STATUS" "HYPERVISOR" "Pre-check-completed"
echo -e "${BLUE}====================================================================================================${NC}"

# --- 3. Print Results (Single Row) ---
printf "%-15s | %-15s | %-15s | %-15s | %-15s\n" "$SNAME" "$UPTIME" "$SSH_STAT" "$HYPER" "$pre"

# --- 4. Disk Usage Section ---
echo ""
echo ""
echo -e "${GREEN}DISK USAGE (df -Th):${NC}"
#echo "----------------------------------------------------------------------------------------------------"
df -Th | grep -v 'tmpfs\|devtmpfs'
echo -e "====================================================================================================${NC}"
#echo -e "${BLUE}====================================================================================================${NC}"
