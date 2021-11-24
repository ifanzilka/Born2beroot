#! /bin/bash
wall $'#Architecture: ' `uname -a` \
$'\n#CPU physical: ' `cat /proc/cpuinfo | grep "physical id" | sort | uniq | wc -l` \
$'\n#vCPU: ' `nproc`\
$'\n#Memory Usage: ' `free -m | grep Mem | awk ' {printf "%d/%dMB (%.2f%%)\n",$3,$2, $3*100/$2} '` \
$'\n#Disk Usage: ' `df -k | grep root | awk '{ printf "%d",$3 / 1024} '``df -h | grep root | awk '{ printf "/%s (%s)\n",$2, $5} '`\
$'\n#CPU Load: ' `top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}'`\
$'\n#Last boot: ' `who -b | awk '{print $3 " " $4}'`\
$'\n#LVM use: ' `lsblk | grep lvm  > /dev/null ; echo $? | awk ' {if ($1 == "0") print "yes"; else print "no"}'`\
$'\n#Connection TCP: ' ` netstat -an | grep ESTABLISHED | wc -l` "ESTABLISHED"\
$'\n#User log: ' `who | wc -l`\
$'\n#Network: IP ' `hostname -I` " ("`ip a | grep link/ether | awk '{print $2}'`")" \
$'\n#Sudo: ' `sudo cat /var/log/sudo/logs_sudo | grep COMMAND | wc -l`
