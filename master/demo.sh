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

# On Master configure replication
${MYSQL}"GRANT REPLICATION SLAVE ON *.* TO hudl@192.168.50.20 IDENTIFIED BY 'demo'"
${MYSQL}"FLUSH PRIVILEGES"
${MYSQL}"USE User_Profiles"
${MYSQL}"FLUSH TABLES WITH READ LOCK"
${MYSQL}"SHOW MASTER STATUS"
	     
# Refresh mysqld
sudo service mysqld restart

# Gather necessary info for replication and send to slave
${MYSQL}"SHOW MASTER STATUS" | grep my | awk '{print $1}' > ~/repinfo
${MYSQL}"SHOW MASTER STATUS" | grep my | awk '{print $2}' >> ~/repinfo
scp repinfo prod-slave:~

# Create initial dump of database
#mysqldump -uhudl -pdemo User_Profiles > User_Profiles.sql
