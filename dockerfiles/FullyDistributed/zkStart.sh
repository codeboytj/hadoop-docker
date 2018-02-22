#!/bin/bash

mkdir /var/lib/zookeeper 
touch /var/lib/zookeeper/myid
echo $ZOO_MY_ID >> /var/lib/zookeeper/myid

OLD_IFS="$IFS"
IFS=" "
arr=($ZOO_SERVERS)
IFS="$OLD_IFS"
for s in ${arr[@]}
do
    echo "$s" >> /usr/local/zookeeper/conf/zoo.cfg
done

