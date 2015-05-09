#! /bin/bash

echo "------ HUDL DEMO BOOTSTRAP v1.0 ------"
# This file will simply make a few modifications on top of a base centos 6.6 image

# Ensure OS Packages are updated
echo "Updated OS Packages ..."
#yum -y update

# Install mysql
echo "Installing MYSQL Packages ..."
yum --nogpgcheck -y install mysql mysql-devel mysql-server MySQL-python

# Ensure we auto start mysql 
chkconfig mysqld on
chkconfig --list mysqld
service mysqld start

# Create db user
mysql -uroot -e "CREATE USER 'hudl'@'localhost' IDENTIFIED BY 'demo'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON * . * TO 'hudl'@'localhost'"

# Generating Keys
#sudo su - hudl -c 'ssh-keygen -t rsa -N "" -f ~/.ssh/id_rsa'

# Edit hosts file
HOST="$(hostname -s)"
HOSTFILE="/etc/hosts"
MASTER="prod-master"
SLAVE="prod-slave"
DEV="hudl-dev"

case ${HOST} in
    ${MASTER})	
		echo "192.168.50.10 prod-master" >> ${HOSTFILE}
		echo "192.168.50.20 prod-slave" >> ${HOSTFILE}
		;;
    ${SLAVE})
		echo "192.168.50.10 prod-master" >> ${HOSTFILE}
                echo "192.168.50.20 prod-slave" >> ${HOSTFILE}
		echo "172.168.50.20 hudl-dev" >> ${HOSTFILE}
		;;
    ${DEV})
		echo "172.168.50.10 prod-slave" >> ${HOSTFILE}
		echo "172.168.50.20 hudl-dev" >> ${HOSTFILE}
		;;
    esac

# Create Banner
cat << 'EOF' > /etc/motd

echo -e "

* * * * * * * * * * * * * * * * * * * * * * * * * *
          WELCOME TO MY HUDL DEMO!
          BY: ORLANDO MORRIESETTE
* * * * * * * * * * * * * * * * * * * * * * * * * *

"
EOF

perl -npe 's/#PrintMotd/PrintMotd/' -i /etc/ssh/sshd_config
service sshd restart
