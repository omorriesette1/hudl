#! /bin/bash

DATE=`date +%Y%d%m`

BACKUP="/home/vagrant/backups/daily/User_Profiles.${DATE}.sql"


mysqldump -uhudl -pdemo --database User_Profiles > ${BACKUP}
gzip -c ${BACKUP}

sudo service mysqld restart
