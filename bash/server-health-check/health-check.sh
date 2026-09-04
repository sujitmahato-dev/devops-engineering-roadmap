#!/bin/bash

echo "================================"
echo "Starting Linux Health Check..."
echo "================================"

echo
echo "Hostname:"
hostname

echo 
echo "Operating System:"
cat /etc/os-release

echo
echo "Kernel Version:"
uname -r

echo 
echo "Current user"
whoami

echo 
echo "Disk Usage:"
df -h

echo
echo "Memory Usage:"
free -h

echo
echo "CPU Information:"
lscpu

echo  
echo "Uptime:"
uptime

echo
echo "IP Address:"
hostname -I

echo
echo "Listening Ports:"
ss -lnt | head

echo
echo "Top 5 Memory Consuming Processes:"
ps aux --sort=-%mem | head -n 6

echo
echo "Health Check Completed."