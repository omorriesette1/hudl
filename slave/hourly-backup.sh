#! /bin/bash

#BACKUP="~/backups/hourly/User_Profiles.sql"

mysqldump -uhudl -pdemo --database User_Profiles > User_Profiles.sql
scp User_Profiles.sql hudl-dev:~
ssh hudl-dev ~/dev/restore-backup.sh

sudo service mysqld start
