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

# Set Global Variables
MYSQL="mysql -uroot -e"
REPINFO="/home/vagrant/repinfo"


# Usage
SCRIPT=$(basename $0)
usage() {
    cat << 'EOF'

    Usage: ${SCRIPT} [OPTIONS]

    This script will setup database replication and enable periodic backups.

    OPTIONS:
    -s, --start  : Automates complete configuration and setup of mysql replication and backup
    -i, --insert : Create a new database entry
    -v, --verify : Return the last 3 rows of the database
    -h, --help  : Display this help message

EOF
exit 1;
}

# Begin Replication Setup
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
    ssh prod-slave "bash ~/slave/demo-slave.sh"
}

insert(){
shift 
if [ $# -ne 6 ]; then
# Usage
    echo ""
    echo "Usage: ${SCRIPT} --insert [NAME PASS EMAIL PHONE]"
    echo ""
    exit 1;
else

    local _name=$1
    local _pass=$2
    local _email=$3
    local _phone=$4

    ${MYSQL}"Use User_Profiles; INSERT INTO profiles (id, username, password, email, phone) VALUES
    (NULL,'$_name', SHA1('$_pass'), '$_email', '$_phone')"
fi
}

verify(){
# Print the last 3 entries entered in the database
echo
echo "====== MASTER DATABASE ======"
${MYSQL}"USE User_Profiles; SELECT * FROM profiles ORDER by ID ASC LIMIT 0,${2}"
echo 
echo

echo "====== SLAVE DATABASE ======"
ssh prod-slave "mysql -uroot -e 'USE User_Profiles; SELECT * FROM profiles ORDER by ID ASC LIMIT 0,${2}'";
echo
}

case "$1" in
            -s|--start) start
			;;
	   -i|--insert) insert "$@" verify $@
                        ;;
	   -v|--verify) verify $@
			;;
             -h|--help) usage
                        ;;
                     *) usage
                        ;;
esac
