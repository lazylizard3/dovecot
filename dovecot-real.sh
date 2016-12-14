#! /bin/bash

d=$(date +%b" "%d)
echo "$d"

cat dovecot.log.2 | grep "$d"|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$1=""}1'|awk '{$2=""}1'|sed 's/shadow//g'|sed 's/://g'| sed 's/(//g'| sed 's/)//g'|awk '{if (/OK.*user=/) {print x;};x=$0}' | sort |uniq > unique.log

FILE=./unique.log;
 for ip in `cat $FILE |cut -d ',' -f 1 |sort |uniq`;
 do { COUNT=`grep ^$ip $FILE |wc -l`;
 if [[ "$COUNT" -gt "1" ]]; then echo "$COUNT:   $ip" >> count.log ;
 fi }; done

echo "$ip"
echo $COUNT

count=count.log

if [ -f $count ];
then
   mail -s "too many dovecot logins today $d" liangzhu@bii.a-star.edu.sg < count.log
else
   echo "File $count does not exist."
fi

rm -f count.log
