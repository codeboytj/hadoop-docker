#!/bin/bash
/etc/init.d/ssh start
sbin/start-dfs.sh
sbin/start-yarn.sh
