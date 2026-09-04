#!/bin/bash

echo "================================"
echo "Starting Linux Health Check..."
echo "================================"

HOSTNAME=$(hostname)
CURRENT_USER=$(whoami)
UPTIME=$(uptime -p)
IP_ADDRESS=$(hostname -I | awk '{print $1}')
DISK_USAGE=$(df -h)
OS_TYPE=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '=' -f2 | tr -d '"')

echo
echo "Hostname:"
echo $HOSTNAME

echo 
echo "Operating System: $OS_TYPE"
cat /etc/os-release

echo
echo "Kernel Version:"
uname -r

echo 
echo "Current user: $CURRENT_USER"

echo 
echo "Disk Usage: $DISK_USAGE"

echo
echo "Memory Usage:"
free -h

echo
echo "CPU Information:"
lscpu

echo  
echo "Uptime: $UPTIME"

echo
echo "IP Address: $IP_ADDRESS"

echo
echo "Listening Ports:"
ss -lnt | head

echo
echo "Top 5 Memory Consuming Processes:"
ps aux --sort=-%mem | head -n 6

DISK_USAGE_PERCENT=$(df -h | awk '$NF=="/"{printf "%s", $5}')
if [ ${DISK_USAGE_PERCENT%?} -gt 80 ]; then
    echo "Warning: Disk usage is above 80%."
else
    echo "Disk usage is within acceptable limits."    
fi

echo
echo "Health Check Completed."