#!/bin/bash

yum install nfs-utils nfs-utils-lib -y

chkconfig nfs on 
service rpcbind start
service nfs start

mkdir /share

echo "/share 192.168.50.11(rw,sync,no_root_squash,no_subtree_check)" >> /etc/exports

exportfs -a

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-port=111/udp --permanent
firewall-cmd --add-port=2049/udp --permanent
firewall-cmd --add-port=20048/udp --permanent
firewall-cmd --reload