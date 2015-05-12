#! /bin/bash

# ***********************************************************
#   Hudl Infrastructure Engineer Demo
#   Version 1
# ***********************************************************
#
# Options for the script
# --start        <Interface Name>
# --stop        <Appliance Name>
# --status       <Primary link ([1-9])>
#
# ***********************************************************

set -e

MYSQL="mysql -uroot -e"
ERROR_LOG=~/demo.err
echo -n > $ERROR_LOG

SCRIPT=$(basename $0)
usage() {
cat << 'EOF'

Usage: ${SCRIPT} [OPTIONS]

This script will setup database replication and enable periodic backups.

OPTIONS
       --start  : Automates complete configuration and setup of mysql replication and backup
      --status  : Verify replication is properly syncing
   -h | --help  : Display this help message

EOF
exit 1;
}



################ On Master configure replication
${MYSQL}"GRANT REPLICATION SLAVE ON *.* TO 'hudl'@'%' IDENTIFIED BY 'demo'"
${MYSQL}"FLUSH PRIVILEGES"

${MYSQL}"USE User_Profiles"
${MYSQL}"FLUSH TABLES WITH READ LOCK"
${MYSQL}"SHOW MASTER STATUS"
	     
sudo service mysqld restart

${MYSQL}"SHOW MASTER STATUS" | grep my | awk '{print $1}' > ~/repinfo
${MYSQL}"SHOW MASTER STATUS" | grep my | awk '{print $2}' >> ~/repinfo

scp repinfo prod-slave:~
mysqldump -uhudl -pdemo User_Profiles > User_Profiles.sql



################ On Slave configure replication
ssh vagrant@prod-slave "bash ~/demo-slave.sh"

#case "$1" in
#               --start)  echo "STARTING ..."
#                         ;;
#              --status)  echo "STATUS ..."
#                         ;;
#             -h|--help)  usage
#                         ;;
#                     *)  usage
#                         ;;
#esac
