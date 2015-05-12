#!/bin/bash

MYSQL="mysql -uroot -e"
REPINFO="~/repinfo"

# Begin replication process on master
#ssh vagrant@prod-master "bash ~/master/demo.sh"

# Configure replication on slave
#scp prod-master:~/User_Profiles.sql ~/backups

if [ -f ${REPINFO} ]; then
    MASTER_LOG=`sed -n '1p' ${REPINFO}`
    MASTER_POS=`sed -n '2p' ${REPINFO}`
fi

${MYSQL}"CHANGE MASTER TO MASTER_HOST='192.168.50.10', MASTER_USER='hudl', MASTER_PASSWORD='demo', MASTER_LOG_FILE='${MASTER_LOG}', MASTER_LOG_POS=${MASTER_POS}"

sudo service mysqld restart

${MYSQL}"slave start"
${MYSQL}"show slave status\G"
