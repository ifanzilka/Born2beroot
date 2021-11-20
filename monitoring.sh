#! /bin/bash
wall $'#Architecture: ' `uname -a` \
$'\n#CPU physical: ' `nproc` \
$'\n#vCPU: ' `cat /proc/cpuinfo | grep processor | wc -l`\
$'\n#Memory Usage: ' `free -m | grep Mem | awk ' {printf "%d/%dMB (%.2f%%)\n",$3,$2, $3*100/$2} '` \
$'\n#Disk Usage: ' `df -k | grep root | awk '{ printf "%d",$3 / 1024} '``df -h | grep root | awk '{ printf "/%s (%s)\n",$2, $5} '`\
$'\n#CPU Load: ' `cat /proc/loadavg  | awk '{ printf "%.1f%%" , $1}'`\
$'\n#Last boot: ' `who -b | awk '{print $3 " " $4}'`\
$'\n#LVM use: ' `lsblk | grep lvm  > /dev/null ; echo $? | awk ' {if ($1 == "0") print "yes"; else print "no"}'`\
$'\n#Connection TCP: ' ` netstat -an | grep ESTABLISHED | wc -l` "ESTABLISHED"\
$'\n#User log: ' `who | wc -l`\
$'\n#Network: IP ' `hostname -I` " ("`ip a | grep link/ether | awk '{print $2}'`")" \
$'\n#Sudo: ' `cat sudo/sudo.log | grep COMMAND | wc -l`