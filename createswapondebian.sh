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

swapfile=$(readlink -f /mnt/1GB.swap)

fallocate -l 1G -o $swapfile
dd if=/dev/zero of=$swapfile bs=1024 count=1048576 -c
mkswap -v $swapfile
chmod 600 $swapfile

swapon $swapfile
echo '/mnt/1GB.swap  none  swap  sw 0  0' >> /etc/fstab
sysctl vm.swappiness=10

exit
