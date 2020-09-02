#!/bin/bash

yum install nfs-utils nfs-utils-lib -y

chkconfig nfs on 
service rpcbind start
service nfs start

mkdir /share
mkdir /share/upload 
sudo chgrp vagrant /share/upload
chmod g+rw /share/upload

echo "/share 192.168.50.11(rw,async,no_subtree_check,no_root_squash)" >> /etc/exports
echo "/share/upload 192.168.50.11(rw,async,no_subtree_check,all_squash,anonuid=1000,anongid=1000)" >> /etc/exports

exportfs -a

systemctl enable firewalld
systemctl start firewalld
firewall-cmd --add-port=111/udp --permanent
firewall-cmd --add-port=2049/udp --permanent
firewall-cmd --add-port=20048/udp --permanent
firewall-cmd --reload