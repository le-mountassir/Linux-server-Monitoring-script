#!/bin/bash

#------ram utils
free_ram=$(free -m | head -2 | tail -1 | awk '{print $2}')
used_ram=$(free -m | head -2 | tail -1 | awk '{print $3}')
per_ram=$(free -m | head -2 |tail -1 | awk '{printf("%.2f", $3/$2*100)}')

#------disk utils
free_disk=$(df -Bg | grep '/dev/' | grep -v '/boot' | awk '{free_d += $2} END {print free_d}')
used_disk=$(df -Bm | grep '/dev/' | grep -v '/boot' | awk '{used_d += $3} END {print used_d}')
per_disk=$(df -Bm | grep '/dev/' | grep -v '/boot' | awk '{used_d += $3} {free_d += $2} END {printf("%d"), used_d/free_d*100}')

#-----lvm
lvm_check=$(lsblk | grep lvm | wc -l)

wall "    #Architecture: $(uname -a)
    #CPU physical: $(cat /proc/cpuinfo | grep "physical id" | wc -l)
    #vCPU: $(cat /proc/cpuinfo | grep "processor" | wc -l)
    #Memory Usage: $used_ram/${free_ram}MB ($per_ram%)
    #Disk Usage: $used_disk/${free_disk}Gb ($per_disk%)
    #CPU load: $(top -n1 | grep "Cpu" | awk '{printf("%.1f%%"), $2 + $4}')
    #Last boot: $(who -b | awk '{print $3 " " $4}')
    #LVM use: $(if [ $lvm_check -eq 0 ]; then echo no; else echo yes; fi)
    #Connetions TCP: $(cat /proc/net/sockstat | awk '{print $3}' | head -2 | tail -1) ESTABLISHED
    #User log: $(users | wc -w)
    #Network: IP $(hostname -I) $(ip link | awk '{print $2}' | tail -1)
    #Sudo: $(journalctl _COMM=sudo -q | grep COMMAND | wc -l) cmd"
