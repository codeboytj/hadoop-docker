#!/bin/bash

chmod 777 ./zookeeper/zkStart.sh
/bin/bash ./zookeeper/zkStart.sh
/usr/sbin/sshd -D
