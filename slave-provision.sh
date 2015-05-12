#! /bin/bash

HOSTFILE="/etc/hosts"
HOME="/home/vagrant"

# Edit hosts file
echo "192.168.50.10 prod-master master" >> ${HOSTFILE}
echo "192.168.50.20 prod-slave slave" >> ${HOSTFILE}
echo "172.168.50.20 hudl-dev dev" >> ${HOSTFILE}


# Edit my.cnf for replication
cat << 'EOF' > /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
symbolic-links=0
server-id = 2
master-host=192.168.50.10
master-connect-retry=30
master-user=hudl
master-password=demo
replicate-do-db=User_Profiles
relay-log=slave-relay-bin
relay-log-index=slave-relay-bin.index
relay-log=slave-relay-bin
log-error = /var/lib/mysql/mysql.err
master-info-file = /var/lib/mysql/mysql-master.info
relay-log-info-file = /var/lib/mysql/mysql-relay-log.info
log-bin = /var/lib/mysql/mysql-bin

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF


# Create directory for backups
mkdir -p $HOME/backups/{daily,hourly}
chown -R vagrant.vagrant $HOME/backups

# Configure Replication

# Setting Auto Backup Cron Jobs
cp $HOME/slave/hourly-backup.sh /etc/cron.hourly/
cp $HOME/slave/daily-backup.sh /etc/cron.daily/

# Add slave scripts to path
echo "export PATH=$PATH:/home/vagrant/slave" >> ~/.bashrc
