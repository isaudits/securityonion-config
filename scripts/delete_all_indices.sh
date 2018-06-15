#!/bin/bash
# This script will delete all logstash indices from Elasticsearch database
# Use with caution!!!


if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

so-elastic-stop
docker exec so-curator curator_cli --config /etc/curator/config/curator.yml delete_indices --filter_list '[{"filtertype":"pattern","kind":"prefix","value":"logstash"}]'
so-elastic-start