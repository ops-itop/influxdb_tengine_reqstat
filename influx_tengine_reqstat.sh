#!/bin/bash

datadir="data_tengine_reqstat"
extdir=$(cd `dirname $0`;pwd)
basedir="$extdir/$datadir"
[ ! -d $basedir ] && mkdir $basedir
if [ $# -eq 1 ];then
	nginxlist="$basedir/$1"
else
	nginxlist="$basedir/nginx.list"
fi
reqstat=":8000/reqstat"

tmpdir="$basedir/tmp"
[ ! -d $tmpdir ] && mkdir $tmpdir
log="$tmpdir/influx.push.log"

function getData()
{
	while read line;do
	{
		cluster=`echo $line |cut -f1 -d','`
		server=`echo $line |cut -f2 -d','`
		tag="reqstat,cluster=$cluster,server=$server,app=$app"
		timedate=`date +%Y%m%d%H%M%S`
		file_push="$tmpdir/influx.$server.push"
		curl -s --connect-timeout 1 -m 1 "http://$server$reqstat" |awk -F ',' -v cluster=$cluster -v server=$server '{
			if($1==""){
				app="UNDEFINED"
			}else{
				app=$1
			}
			
			print "reqstat,cluster="cluster",server="server",app="app" bytes_in="$2",bytes_out="$3\
				",conn_total="$4",req_total="$5",http_2xx="$6",http_3xx="$7",http_4xx="$8\
				",http_5xx="$9",http_other_status="$10",rt="$11",ups_req="$12",ups_rt="$13\
				",ups_tries="$14",http_200="$15",http_206="$16",http_302="$17",http_304="$18\
				",http_403="$19",http_404="$20",http_416="$21",http_499="$22",http_500="$23\
				",http_502="$24",http_503="$25",http_504="$26",http_508="$27\
				",http_other_detail_status="$28",http_ups_4xx="$29",http_ups_5xx="$30
		}'

	} done <$nginxlist
	wait
}

getData
