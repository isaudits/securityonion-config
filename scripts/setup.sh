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

CONFIG="/etc/logstash/custom"
if [ -d "$CONFIG" ]; then 
    if [ -L "$CONFIG" ]; then 
        echo "Logstash custom config directory already symlinked; moving on..."
    else
        echo "Symlinking custom logstash config files..."
        rmdir "$CONFIG"
        ln -s "$DIR/logstash" "$CONFIG"
    fi
fi

echo "Relinking existing logstash config files..."
cd /etc/logstash/conf.d/
rm *
ln -s ../conf.d.available/*.conf ./

echo "Removing links to unused logstash config files..."
#Files we are replacing with custom ones
rm 1004_preprocess_syslog_types.conf
rm 6200_firewall_fortinet.conf
#Other unused ones
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

CONFIG="/etc/syslog-ng/conf.d"
if [ -d "$CONFIG" ]; then 
    if [ -L "$CONFIG" ]; then 
        echo "Syslog-ng custom config directory already symlinked; moving on..."
    else
        echo "Symlinking custom Syslog-ng config files..."
        rmdir "$CONFIG"
        ln -s "$DIR/syslog-ng" "$CONFIG"
    fi
fi

#Add include line for custom syslog-ng configs if not present
LINE='@include "/etc/syslog-ng/conf.d/*.conf"'
FILE="/etc/syslog-ng/syslog-ng.conf"
grep -qF -- "$LINE" "$FILE" || echo "$LINE" >> "$FILE"

echo "Restarting services..."
service syslog-ng restart
so-elastic-restart