#!/bin/bash
echo `hostname`

printf "CPU "
lscpu | grep "Model name" | awk '{print $3 " " $4 " " $5 " " $6}'

printf "CPU Freq: "
lscpu | grep "Model name" | awk '{print $8}'

printf "Current Freq: "
lscpu | grep "CPU MHz" | awk '{print $3 "MHz"}'

printf "Total RAM: "
free | grep "Память:" | awk '{print $2}'

printf "Free RAM: "
free | grep "Подкачка:" | awk '{print $4}'

echo ""


i=0


ps -axo pid,%cpu,%mem,pri,ni,command --sort=-%cpu,-%mem | while read line
do

   if (($i!=0))
   then
      echo "Process #$i"

      printf "PID: "
      echo $line | grep " " | awk '{print $1}'

      printf "CPU: "
      echo $line | grep " " | awk '{print $2}'

      printf "MEM: "
      echo $line | grep " " | awk '{print $3}'

      printf "Prority: "
      echo $line | grep " " | awk '{print $4}'

      printf "Access Rights: "
      echo $line | grep " " | awk '{print $5}'

      printf "WHAT: "
      echo $line | grep " " | awk '{print $6}'

      echo "____________________"
   fi


   let i=i+1

   if (($i==11))
   then
      break
   fi
done

count=`dpkg -l | grep "i386" | wc -l`
countAll=`dpkg -l | tail -n +8 | wc -l`
let percent=($count*100)/$countAll

echo "Installed $percent% 32x packages"
echo ""

echo "RAID:"

sudo mdadm --detail --scan --verbose | grep "ARRAY" | while read devs
do
   nameRAID=`echo $devs | grep "ARRAY" | awk '{print $2}'`
   printf "Array: "
   echo $nameRAID

   printf "	Version: "x
   version=`echo $devs | grep "ARRAY" | awk '{print $5}'`
   echo $version | awk -F "=" '{print $2}'

   printf "	Type: "
   type=`echo $devs | grep "ARRAY" | awk '{print $3}'`
   echo $type | awk -F "=" '{print $2}'

   printf "	Size: "
   size=`sudo mdadm --detail $nameRAID | grep "Array Size :" | awk '{print $7 " " $8}'`
   echo $size | awk -F ")" '{print $1}'

   echo "	Devices: "
   countDev=`sudo mdadm --detail $nameRAID | grep "Total Devices : " | awk '{print $4}'`
   sudo mdadm --detail $nameRAID | tail -n -$countDev | while read line
   do
      echo $line | awk -F " " '{print "	   " $5 " " $6 " " $7}'
   done

   echo ""
done

