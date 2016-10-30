#forgot to configure a swap file?
# this script configures a swap file afterwards

fallocate -l 1G /mnt/1GB.swap
mkswap /mnt/1GB.swap
chmod 600 /mnt/1GB.swap

swapon /mnt/1GB.swap
echo '/mnt/1GB.swap  none  swap  sw 0  0' >> /etc/fstab
vm.swappiness=10

