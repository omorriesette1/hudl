#! /bin/bash

echo "------ HUDL DEMO BOOTSTRAP v1.0 ------"
# This file will simply make a few modifications on top of a base centos 6.6 image

# Ensure OS Packages are updated
echo "Updated OS Packages ..."
#yum -y update

# Setup Percona Repo
echo "Installing Percona Repo (XtraBackup) ..."
yum install -y --nogpgcheck http://www.percona.com/downloads/percona-release/redhat/0.1-3/percona-release-0.1-3.noarch.rpm

# Install mysql and xtrabackup
echo "Installing Database Packages ..."
yum --nogpgcheck -y install mysql mysql-devel mysql-server MySQL-python xtrabackup

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
		echo "192.168.50.10 prod-master master" >> ${HOSTFILE}
		echo "192.168.50.20 prod-slave slave" >> ${HOSTFILE}
		;;
    ${SLAVE})
		echo "192.168.50.10 prod-master master" >> ${HOSTFILE}
                echo "192.168.50.20 prod-slave slave" >> ${HOSTFILE}
		echo "172.168.50.20 hudl-dev dev" >> ${HOSTFILE}
		mkdir -p /home/vagrant/data/backups
		;;
    ${DEV})
		echo "172.168.50.10 prod-slave slave" >> ${HOSTFILE}
		echo "172.168.50.20 hudl-dev dev" >> ${HOSTFILE}
		;;
    esac

# Create Banner
cat << 'EOF' > /etc/motd


* * * * * * * * * * * * * * * * * * * * * * * * * *
          WELCOME TO MY HUDL DEMO!
          BY: ORLANDO MORRIESETTE
* * * * * * * * * * * * * * * * * * * * * * * * * *

EOF

perl -npe 's/#PrintMotd/PrintMotd/' -i /etc/ssh/sshd_config
service sshd restart
