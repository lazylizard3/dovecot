#! /bin/bash

#find date
d=$(date +%b" "%d)
#echo "$d"

#how many unique ip should a user successfully login from?
THRES=3

ips=$(cat /var/log/maillog  | grep "$d" | cut -d" " -f 4- |grep "Login: user=" | sort | uniq -c | awk '$1 > t' t=$THRES)

if [ -z "$ips" ]; then
    echo "nothing"
else 
echo "From: somebody@somewhere.somedomain" > dovecot.txt
echo "Subject: too many dovecot logins on $d" >> dovecot.txt
echo "To: somebody@somewhere.somedomain" >> dovecot.txt
echo " " >> dovecot.txt
echo $ips >> dovecot.txt
sendmail -vt < dovecot.txt


fi
