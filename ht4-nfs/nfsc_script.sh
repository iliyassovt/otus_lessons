#!/bin/bash

yum install nfs-utils nfs-utils-lib -y

mkdir -p /share
mount -o udp 192.168.50.10:/share /share

echo "192.168.50.10:/share /share nfs auto,noatime,nolock,bg,nfsvers=3,intr,udp,actimeo=1800 0 0" >> /etc/fstab