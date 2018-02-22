#!/bin/bash

hadoop/bin/hdfs namenode -format
hadoop/sbin/start-dfs.sh
hadoop/sbin/start-yarn.sh
