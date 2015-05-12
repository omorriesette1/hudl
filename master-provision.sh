#! /bin/bash

HOSTFILE="/etc/hosts"

# Edit hosts file
echo "192.168.50.10 prod-master master" >> ${HOSTFILE}
echo "192.168.50.20 prod-slave slave" >> ${HOSTFILE}

# Edit my.cnf for replication
cat << 'EOF' > /etc/my.cnf
[mysqld]
datadir=/var/lib/mysql
socket=/var/lib/mysql/mysql.sock
user=mysql
symbolic-links=0
server-id = 1
binlog-do-db=User_Profiles
relay-log = /var/lib/mysql/mysql-relay-bin
relay-log-index = /var/lib/mysql/mysql-relay-bin.index
log-error = /var/lib/mysql/mysql.err
master-info-file = /var/lib/mysql/mysql-master.info
relay-log-info-file = /var/lib/mysql/mysql-relay-log.info
log-bin = /var/lib/mysql/mysql-bin
innodb_flush_log_at_trx_commit=1
sync_binlog=1

[mysqld_safe]
log-error=/var/log/mysqld.log
pid-file=/var/run/mysqld/mysqld.pid
EOF

# Add master folder to path
export PATH=$PATH:/home/vagrant/master
