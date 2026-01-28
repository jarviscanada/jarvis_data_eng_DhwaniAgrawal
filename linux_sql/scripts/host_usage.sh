#!/bin/bash

psql_host=$1
psql_port=$2
db_name=$3
psql_user=$4
psql_password=$5

# validate args
if [ "$#" -ne 5 ]; then
  echo "Illegal number of parameters"
  exit 1
fi

# save hostname and vmstat output
hostname=$(hostname -f)
vmstat_mb=$(vmstat --unit M)

# parse usage metrics
memory_free=$(echo "$vmstat_mb" | awk '{print $4}' | tail -n1 | xargs)
cpu_idle=$(echo "$vmstat_mb" | awk '{print $15}' | tail -n1 | xargs)
cpu_kernel=$(echo "$vmstat_mb" | awk '{print $14}' | tail -n1 | xargs)
disk_io=$(vmstat -d | awk '{print $10}' | tail -n1 | xargs)
disk_available=$(df -BM / | tail -n1 | awk '{print $4}' | sed 's/M//')

# UTC timestamp
timestamp=$(date -u +"%Y-%m-%d %H:%M:%S")

# subquery to get host id
host_id="(SELECT id FROM host_info WHERE hostname='$hostname')"

# insert statement
insert_stmt="
INSERT INTO host_usage(host_id, timestamp, memory_free, cpu_idle, cpu_kernel, disk_io, disk_available)
VALUES ($host_id, '$timestamp', $memory_free, $cpu_idle, $cpu_kernel, $disk_io, $disk_available);"

# execute insert
export PGPASSWORD=$psql_password
psql -h $psql_host -p $psql_port -d $db_name -U $psql_user -c "$insert_stmt"

if [ $? -eq 0 ]; then
  echo "$(date): host_usage data inserted successfully" >> /tmp/host_usage.log
else
  echo "$(date): ERROR inserting host_usage data" >> /tmp/host_usage.log
fi

exit $?

