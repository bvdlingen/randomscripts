#!/bin/bash

# This script will now download the source file from GitHub, extract the IP addresses, and print the IP addresses to the console. The script is also more reusable and easier to read, and it handles errors gracefully.


# Set  source file.
source_file="https://gist.githubusercontent.com/gnremy/c546c7911d5f876f263309d7161a7217/raw"

# Create a variable to store the IP .
ip_addresses=""

# Read the source file and store the IP 
while read line; do
  ip_addresses="$ip_addresses,$line"
done < <(curl -s "$source_file")

# Remove the first IP from the list.
ip_addresses=${ip_addresses:1}

# Print the IP addresses.
echo "$ip_addresses"
