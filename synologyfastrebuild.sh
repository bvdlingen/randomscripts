 # source https://forum.synology.com/enu/viewtopic.php?t=121532
 
 
echo 16384 >/sys/block/md2/md/stripe_cache_size
echo 45000 > /proc/sys/dev/raid/speed_limit_max
echo 45000 > /proc/sys/dev/raid/speed_limit_min

#monitor progress
while true; do clear; cat /proc/mdstat; sleep 2; done
