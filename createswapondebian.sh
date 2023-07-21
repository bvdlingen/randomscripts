#!/bin/sh

: << ~_~

shit my VPS server hangs cause there is no swap!

Will work on any Linux distribution that has the fallocate, dd, mkswap, swapon, echo, and sysctl commands. This includes most major Linux distributions, such as Ubuntu, Debian, CentOS, Fedora, and openSUSE.
The script will also work on other Unix-like operating systems, such as FreeBSD and macOS. However, the exact commands and options may vary depending on the operating system.

List of the commands and options used in the bash script, along with their descriptions:

    fallocate: Creates a file of a specified size.
    dd: Copies data from one file to another.
    mkswap: Creates a swap area on a file.
    swapon: Enables a swap area.
    echo: Writes a string to a file.
    sysctl: Sets a kernel parameter.

This script creates a 1GB swapfile and enables it.

~_~


swapfile_size=1G
swapfile_path="/mnt/1GB.swap"
vm_swappiness=10

swapfile=$(readlink -f $swapfile_path)

fallocate -l $swapfile_size -o $swapfile
dd if=/dev/zero of=$swapfile bs=1024 count=1048576 -c
mkswap -v $swapfile
chmod 600 $swapfile

swapon $swapfile
printf '/mnt/%s  none  swap  sw 0  0' "$swapfile_path" >> /etc/fstab
sysctl vm.swappiness=$vm_swappiness

exit
