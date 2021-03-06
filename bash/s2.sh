#!/bin/bash 

if(($# != 2)) 
then 
echo “Wrong numbers of parameters” 
else 
direc=$1 
ext=$2 
a=10 
b=5 
c=99 
nmfiles=$(expr $RANDOM % $a) 
for((i=0; i<=$nmfiles; i++)) 
do 
part=$(eval date +%s)$RANDOM 
fn="$direc/$part.$ext" 
touch $fn 
nmline=$(expr $RANDOM % $a) 
for ((j=0; j<=$nmline; j++)) 
do 
let id=$(eval date +%s)/$(expr $RANDOM+1) 
num="" 
for((k=0; k<=$(expr $RANDOM % $b); k++)) 
do 
num="$num $(expr $RANDOM % $c)" 
done 
echo $id"ID" $num >> "$fn" 
done 
md5sum $fn | awk '{print $1}' >> $fn.md5 
done
fi
