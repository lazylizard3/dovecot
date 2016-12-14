#! /bin/bash

d=$(date +%b" "%d)
echo "$d"

unique=`cat dovecot.log.2 | grep "$d"|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$2=""}1'|sed 's/shadow//g'|sed 's/://g'| sed 's/(//g'| sed 's/)//g'|awk '{if (/OK.*user=/) {print x;};x=$0}' | sort |uniq`


#echo $unique

#read -a arr <<<$unique

#echo $unique

for uniques in $unique
do
 read user ip <<<$(IFS=","; echo $uniques)

echo $ip
echo $user

count="$count
$user"
done

read -a arr <<<$count

uniquser=($(printf "%s\n" "${count[@]}" | sort -u)); 
uniquser=`echo "${uniquser[@]}"`
#read -a arr <<<$uniquser
echo $uniquser
#echo $arr
echo $count
#uniqusers=`echo "$uniquser"| awk '{print $1}'`
#echo $uniqusers


IFS=" ";
for uniqs in $uniqusers
do
   #echo $uniqs 
   counter=`echo $count | grep -c $uniqs`;
       if [ $counter -gt 1 ] ; then
	echo "send alert $counter for $uniqs"
 	elif
   	[ $counter -lt 2 ] ; then
	echo "$counter $uniqs no send alert"
       fi
done



