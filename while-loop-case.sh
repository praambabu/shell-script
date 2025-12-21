#!/bin/bash
while true
do
clear
echo -e "Pls select below options and enter:\n"
echo -e "1. Ping\n"
echo -e "2. Uptime\n"
echo -e "3. Health-check\n"
echo -e "4. Reboot\n"
echo -e "5. Service-status\n"
echo -e "6. Cat\n"
echo -e "7. Adhoc commands\n"
echo -e "8. User create\n"
echo -e "0. Exit"
echo " "

read input
case $input in
    0) 
    break
    ;;
    1) 
    clear
    echo "Ping status"
    /root/shell-script/1-ping.sh
    sleep 2 
    ;;
    2) 
    clear
    echo "Uptime status"
    /root/shell-script/2-uptime.sh
    sleep 2 
    ;;
    3) 
    clear
    echo "Health-check status"
    /root/shell-script/3-health-check.sh
    sleep 2 
    ;;
    4) 
    clear
    echo "Reboot"
    /root/shell-script/4-reboot.sh
    sleep 2 
    ;;
    5) 
    clear
    echo "Service status"
    /root/shell-script/5-service-status.sh
    sleep 2 
    ;;
    6) 
    clear
    echo "cat on file"
    /root/shell-script/6-cat.sh
    sleep 2 
    ;;
    7) 
    clear
    echo "Adhoc command"
    /root/shell-script/7-ad-hoc-command.sh
    sleep 2
    echo " "
    ;;
    8) 
    clear
    echo "User create"
    /root/shell-script/8-user-create.sh
    sleep 2
    echo " "
    ;;
    esac
done
