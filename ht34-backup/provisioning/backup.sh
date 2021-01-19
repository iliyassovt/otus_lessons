#!/bin/bash
# Client and server name
CLIENT=root
SERVER=server
REPOSITORY=$CLIENT@$SERVER:/var/backup/$(hostname)-etc

# Backup
BORG_PASSPHRASE='test' borg create -v --stats --progress $REPOSITORY::"{now:%Y-%m-%d-%H-%M}" /etc 2>&1 | logger -t borg_backup

# After backup
BORG_PASSPHRASE='test' borg prune -v --show-rc --list $REPOSITORY --keep-daily=180 --keep-monthly=12 2>&1 | logger -t borg_backup