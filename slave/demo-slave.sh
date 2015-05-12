#!/bin/bash

MYSQL="mysql -uroot -e"

################ On Slave configure replication
scp prod-master:~/User_Profiles.sql ~
mysqldump -uhudl -pdemo User_Profiles < ~/User_Profiles.sql
### SCRUB DATA


MASTER_LOG=`sed -n '1p' ~/repinfo`
MASTER_POS=`sed -n '2p' ~/repinfo`

${MYSQL}"slave stop"
${MYSQL}"CHANGE MASTER TO MASTER_HOST='192.168.50.10', MASTER_USER='hudl', MASTER_PASSWORD='demo', MASTER_LOG_FILE='${MASTER_LOG}', MASTER_LOG_POS=${MASTER_POS}"
sudo service mysqld restart
${MYSQL}"slave start"
${MYSQL}"show slave status\G"
