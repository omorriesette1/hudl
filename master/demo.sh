#! /bin/bash

# ***********************************************************
#   Hudl Infrastructure Engineer Demo
#   Version 1
# ***********************************************************
#
# Options for the script
# --start        Begin Replication
# --help	 Usage
#
# ***********************************************************

set -e
MYSQL="mysql -uroot -e"
REPINFO="~/repinfo"

SCRIPT=$(basename $0)
usage() {
    cat << 'EOF'

    Usage: ${SCRIPT} [OPTIONS]

    This script will setup database replication and enable periodic backups.

    OPTIONS
	--start  : Automates complete configuration and setup of mysql replication and backup
    -h | --help  : Display this help message

EOF
exit 1;
}


start(){
    # On Master configure replication
    ${MYSQL}"GRANT REPLICATION SLAVE ON *.* TO hudl@192.168.50.20 IDENTIFIED BY 'demo'"
    ${MYSQL}"FLUSH PRIVILEGES"
    ${MYSQL}"USE User_Profiles"
    ${MYSQL}"FLUSH TABLES WITH READ LOCK"
    ${MYSQL}"SHOW MASTER STATUS"
	     
    # Refresh mysqld
    sudo service mysqld restart

    # Gather necessary info for replication and send to slave
    ${MYSQL}"SHOW MASTER STATUS" | grep my | awk '{print $1}' > $REPINFO
    ${MYSQL}"SHOW MASTER STATUS" | grep my | awk '{print $2}' >> $REPINFO

    if [ -f $REPINFO ]; then
	scp $REPINFO prod-slave:~
    else
	echo "$REPINFO does not exist" 
	exit 1;
    fi

    # On Slave configure replication
    ssh prod-slave "bash ~/demo-slave.sh"
}


case "$1" in
               --start)  start
                         ;;
             -h|--help)  usage
                         ;;
                     *)  usage
                         ;;
esac
