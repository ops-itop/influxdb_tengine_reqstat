#!/bin/bash

############################
# Usage:
# File Name: cron.sh
# Author: annhe  
# Mail: i@annhe.net
# Created Time: 2016-08-04 22:18:47
############################

basedir=$(cd `dirname $0`; pwd)
cd $basedir

# 判断telegraf是否在运行
ps aux |grep telegraf |grep "reqstat.conf" |grep -v "grep" && st=1 || st=0
#./control status |grep "is running" && st=1 || st=0
if [ $st -eq 0 ];then
	rm -f telegraf.pid
	./control start
	sleep 3
	./control status
fi
