#! /bin/bash

#find date
d=$(date +%b" "%d)
#echo "$d"

#how many unique ip should a user successfully login from?
THRES=10

d="Nov 29"
# cat log file, grep date, cut first 6 columns, find OK and print line before it, trim all until we get a ip and name pair, sort+uniq to find unique ips, if appear more than THRES times show it
pairs=$(cat dovecot.log.1 | grep "$d" | cut -d" " -f 6- | awk '{if (/OK.*user=/) {print x;};x=$0}'  | sed 's/shadow(//' | sed 's/):.*$//' | sort | uniq | cut -d ',' -f 1 | sort | uniq -c | awk '$1 > t' t=$THRES)


#echo "$pairs"


#if pairs is empty say "nothing", else extract the names out and send us the log lines
if [ -z "$pairs" ]; then
    echo "nothing"
else 

for pair in $pairs
do
 IFS=0123456789
pairlist="$pairlist $pair"
done
#echo $pairlist
for listitem in $pairlist
do
  IFS="   "
#echo $listitem
#line=$(cat dovecot.log.1 | grep "$d" |cut -d" " -f 6- | awk '{if (/OK.*user=/) {print x;};x=$0}'  | sed 's/shadow(//' | sed 's/):.*$//' | grep $listitem | sort | uniq )

line=$(cat dovecot.log.1 | grep "$d" | awk '{if (/OK.*user=/) {print x;};x=$0}'  | grep $listitem | sort | uniq )

#echo $line
if [ -z "$pairs" ]; then
    echo "nothing"
else
lines="$lines 
$line"
fi
done

echo "From: somebody@somewhere.somedomain" > dovecot.txt
echo "Subject: $pairlist too many dovecot logins $d" >> dovecot.txt
echo "To: somebody@somewhere.somedomain" >> dovecot.txt
echo " " >> dovecot.txt
echo $lines >> dovecot.txt
sendmail -vt < dovecot.txt


fi
echo $lines 
