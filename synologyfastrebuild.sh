#!/bin/bash

set -e

# Set the stripe cache size
echo 32768 > /sys/block/md2/md/stripe_cache_size

# Set the speed limit
echo 45000 > /proc/sys/dev/raid/speed_limit_max
echo 45000 > /proc/sys/dev/raid/speed_limit_min

# Set the read ahead size
echo 32768 > /sys/block/md2/queue/read_ahead_kb

# Monitor progress
while read line; do
    echo "$line"
    sleep 2
done < /proc/mdstat
