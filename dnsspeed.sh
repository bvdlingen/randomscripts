 #!/bin/bash

set -e

domain_name="digg.com"
dns_server="1.1.1.1"

while true; do
    dig "$domain_name" @"$dns_server" | grep -E "time=.*msec" | printf "%.2fms\n"
    sleep 2
done
