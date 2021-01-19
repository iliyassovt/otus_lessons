#!/bin/bash
yum install -y epel-release
yum install -y borgbackup
BORG_PASSPHRASE='test' borg init -e none root@server:/var/backup/$(hostname)-etc 2>&1 | logger -t borg_backup