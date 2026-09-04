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

LOG_FILE="logs/health_check.log"

echo
echo "Hostname:"
echo $HOSTNAME

echo 
echo "Operating System: $OS_TYPE" >> $LOG_FILE
cat /etc/os-release

echo
echo "Kernel Version:"
uname -r

echo 
echo "Current user: $CURRENT_USER" >> $LOG_FILE

echo 
echo "Disk Usage: $DISK_USAGE" >> $LOG_FILE

echo
echo "Memory Usage:" >> $LOG_FILE
free -h

echo
echo "CPU Information:" >> $LOG_FILE
lscpu

echo  
echo "Uptime: $UPTIME" >> $LOG_FILE

echo
echo "IP Address: $IP_ADDRESS" >> $LOG_FILE

echo
echo "Listening Ports:"
ss -lnt | head

echo
echo "Top 5 Memory Consuming Processes:"
ps aux --sort=-%mem | head -n 6

DISK_USAGE_PERCENT=$(df -h | awk '$NF=="/"{printf "%s", $5}')
if [ ${DISK_USAGE_PERCENT%?} -gt 80 ]; then
    echo "Warning: Disk usage is above 80%." >> $LOG_FILE
else
    echo "Disk usage is within acceptable limits." >> $LOG_FILE    
fi

echo
echo "Health Check Completed."

check_disk_usage() {
    local disk_usage_percent=$(df -h | awk '$NF=="/"{printf "%s", $5}')
    if [ ${disk_usage_percent%?} -gt 80 ]; then
        echo "Warning: Disk usage is above 80%." >> $LOG_FILE
    else
        echo "Disk usage is within acceptable limits." >> $LOG_FILE
    fi
}

check_disk_usage

if check_disk_usage; then
    echo "Disk usage is within acceptable limits."
else
    echo "Warning: Disk usage is above 80%."
fi

check_memory_usage() {
    local memory_usage_percent=$(free | awk '/Mem/{printf("%.0f"), $3/$2 * 100}')
    if [ $memory_usage_percent -gt 80 ]; then
        echo "Warning: Memory usage is above 80%." >> $LOG_FILE
        return 1
    else
        echo "Memory usage is within acceptable limits." >> $LOG_FILE
        return 0
    fi
}

check_memory_usage

check_cpu_usage() {
    local cpu_usage_percent=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')
    if (( $(echo "$cpu_usage_percent > 80" | bc -l) )); then
        echo "Warning: CPU usage is above 80%." >> $LOG_FILE
        return 1
    else
        echo "CPU usage is within acceptable limits." >> $LOG_FILE
        return 0
    fi
}
check_cpu_usage

check_hostname() {
    local hostname=$(hostname)
    if [ -z "$hostname" ]; then
        echo "Warning: Hostname is not set." >> $LOG_FILE
        return 1
    else
        echo "Hostname is set to: $hostname" >> $LOG_FILE
        return 0
    fi
}
check_hostname

check_ip_address() {
    local ip_address=$(hostname -I | awk '{print $1}')
    if [ -z "$ip_address" ]; then
        echo "Warning: IP address is not set." >> $LOG_FILE
        return 1
    else
        echo "IP address is set to: $ip_address" >> $LOG_FILE
        return 0
    fi
}
check_ip_address
check_processes() {
    local top_processes=$(ps aux --sort=-%mem | head -n 6)
    echo "Top 5 Memory Consuming Processes:" >> $LOG_FILE
    echo "$top_processes" >> $LOG_FILE
}
check_processes

check_services() {
    local services=$(systemctl list-units --type=service --state=running)
    echo "Running Services:" >> $LOG_FILE
    echo "$services" >> $LOG_FILE
}
check_services  

main() {
    echo "Starting Linux Health Check..."  >> $LOG_FILE
    check_disk_usage
    check_memory_usage
    check_cpu_usage
    check_hostname
    check_ip_address
    check_processes
    echo "Health Check Completed."
}

main