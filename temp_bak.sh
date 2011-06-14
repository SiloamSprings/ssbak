#!/usr/bin/env bash
# SS917 temporary backup
logger "initiating nss backup via /usr/sbin/temp_bak.sh"
/usr/bin/rsync -rltDvh /media/nss /storage1/SS917/nss &> /tmp/rsync_`/bin/date +%F`.log
logger "backup script terminated"
