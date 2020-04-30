#!/bin/bash

# start ssh server
/etc/init.d/ssh start

# format namenode
$HADOOP_HOME/bin/hdfs namenode -format

# start hadoop
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh
$HADOOP_HOME/sbin/mr-jobhistory-daemon.sh start historyserver

 
printf "Try one of these:
* http://localhost:8088/
* http://localhost:50070/
* http://localhost:50075/
"
# keep container running
# tail -f /dev/null & 
# PID=$!
# i=1
# sp="/-\|"
# echo -n ` `
# while [ -d /proc/$PID ]
# do
#   sleep 0.1
#   printf "\b${sp:i++%${#sp}:1}"
# done

