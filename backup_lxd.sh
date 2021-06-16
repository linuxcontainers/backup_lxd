#!/bin/bash
# Basic shell script to backup required LXD parts ##
## Backup and restore LXD config ##
## Today's date ##
NOW=$(date +'%m-%d-%Y')
# Basic configuration: datestamp e.g. YYYYMMDD
DATE=$(date +"%Y%m%d")

# Location of your backups (create the directory first!)
BACKUP_DIR="/backups/lxd"

# Number of days to keep the directories (older than X days will be removed)
RETENTION=2

# Create a new directory into backup directory location for this date
mkdir -p $BACKUP_DIR/$DATE

## Dump LXD server config ##
lxd init --dump > "$BACKUP_DIR/$DATE/lxd.config.${NOW}"

## Dump all instances list ##
lxc list > "$BACKUP_DIR/$DATE/lxd.instances.list.${NOW}"

## Make sure we know LXD version too ##
snap list lxd > "$BACKUP_DIR/$DATE/lxd-version.${NOW}"

## Backup all Instances
for i in $(lxc list -c n --format csv)
do
     echo "Making backup of ${i} ..."
     lxc export "${i}" "$BACKUP_DIR/$DATE/${i}-backup-$(date +'%m-%d-%Y').tar.xz" --optimized-storage
done

# Remove files older than X days
#
find $BACKUP_DIR/* -mtime +$RETENTION -delete
