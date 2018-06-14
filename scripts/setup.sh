#!/bin/bash

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

#Change working directory to the parent path of this script
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )/.." && pwd )"
cd $DIR

#Clean up existing logstash symlinks
cd /etc/logstash/conf.d/
rm *
ln -s ../conf.d.available/*.conf ./
ln -s $DIR/logstash/*.conf ./
#stuff we aren't going to use
rm 1029_preprocess_esxi.conf
rm 1030_preprocess_greensql.conf
rm 1032_preprocess_mcafee.conf
rm 1998_test_data.conf
rm 6101_switch_brocade.conf
rm 9001_output_switch.conf
rm 9029_output_esxi.conf
rm 9030_output_greensql.conf
rm 9032_output_mcafee.conf
rm 9998_output_test_data.conf

#Delete custom syslog-ng configs and symlink to this repo
rm /etc/syslog-ng/conf.d/*
ln -s $DIR/syslog-ng/* /etc/syslog-ng/conf.d/

#Add include line for custom syslog-ng configs if not present
LINE='@include "/etc/syslog-ng/conf.d/*.conf"'
FILE="/etc/syslog-ng/syslog-ng.conf"
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

#restart services
service syslog-ng restart
so-elastic-restart