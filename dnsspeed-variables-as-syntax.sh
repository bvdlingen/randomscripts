#!/bin/bash

: << ~_~

This script will now use the first and second arguments as the domain_name and dns_server variables. 
This will make the script more flexible, as the user can pass in the domain name and DNS server when the script is executed.

For example: you can run the following command:
bash dns_test.sh  itscrap.com  9.9.9.9

~_~

set -e

domain_name=$1
dns_server=$2

while true; do
    dig "$domain_name" @"$dns_server" | grep -E "time=.*msec" | printf "%.2fms\n"
    sleep 2
done
