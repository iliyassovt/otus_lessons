#!/bin/bash
yum install -y mdadm

mdadm --create --verbose /dev/md0 -l 10 -n 6 /dev/sd{b,c,d,e,f,g}
mdadm --detail --scan --verbose > /etc/mdadm.conf

parted -s /dev/md0 mklabel gpt
parted /dev/md0 mkpart primary ext4 0% 20%
parted /dev/md0 mkpart primary ext4 20% 40%
parted /dev/md0 mkpart primary ext4 40% 60%
parted /dev/md0 mkpart primary ext4 60% 80%
parted /dev/md0 mkpart primary ext4 80% 100%

mkfs.ext4 /dev/md0p1
mkfs.ext4 /dev/md0p2
mkfs.ext4 /dev/md0p3
mkfs.ext4 /dev/md0p4
mkfs.ext4 /dev/md0p5

mkdir -p /mnt/raid10/md0p{1,2,3,4,5}

mount /dev/md0p1 /mnt/raid10/md0p1/
mount /dev/md0p2 /mnt/raid10/md0p2/
mount /dev/md0p3 /mnt/raid10/md0p3/
mount /dev/md0p4 /mnt/raid10/md0p4/
mount /dev/md0p5 /mnt/raid10/md0p5/
