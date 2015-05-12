#! /bin/bash

DATE=`date +%Y%d%m`
LOCATION=/home/vagrant/backups/$1

HOURLY_BACKUP="${LOCATION}/User_Profiles.sql"
DAILY_BACKUP="${LOCATION}/User_Profiles.${DATE}.sql"

sudo service mysqld stop

if [ ${1} == "hourly" ]; then
   mysqldump -uhudl -pdemo --database User_Profiles > ${HOURLY_BACKUP}
   scp ${HOURLY_BACKUP} hudl-dev:~
   ssh hudl-dev ~/dev/restore-backup.sh < ${HOURLY_BACKUP}.gz

elif [ ${1} == "daily" ]; then 
   mysqldump -uhudl -pdemo --database User_Profiles > ${DAILY_BACKUP}
   gzip -c ${DAILY_BACKUP}

else
   echo "$(basename $0) [hourly|daily]"
fi

sudo service mysqld start
