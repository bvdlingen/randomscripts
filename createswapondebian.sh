#!/bin/sh

# shit my VPS server hangs cause I forgot to configure a swap file!
# This script configures a swap _file_ afterwards
# tested on Ubuntu and Debian, but should work everywhere

fallocate -l 1G /mnt/1GB.swap
mkswap /mnt/1GB.swap
chmod 600 /mnt/1GB.swap

swapon /mnt/1GB.swap
echo '/mnt/1GB.swap  none  swap  sw 0  0' >> /etc/fstab
vm.swappiness=10

