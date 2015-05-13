#! /bin/bash

echo "------ HUDL DEMO BOOTSTRAP v1.0 ------"
# This file will simply make a few modifications on top of a base centos 6.6 image

# Install mysql and its dependencies
echo "Installing Database Packages ..."
yum --nogpgcheck -y install mysql mysql-devel mysql-server MySQL-python

# Ensure we auto start mysql 
chkconfig mysqld on
chkconfig --list mysqld
service mysqld start

# Create the hudl db user
mysql -uroot -e "CREATE USER 'hudl'@'localhost' IDENTIFIED BY 'demo'"
mysql -uroot -e "GRANT ALL PRIVILEGES ON * . * TO 'hudl'@'localhost'"


# Create Banner
cat << 'EOF' > /etc/motd


* * * * * * * * * * * * * * * * * * * * * * * * * *
          WELCOME TO MY HUDL DEMO!
          BY: ORLANDO MORRIESETTE
* * * * * * * * * * * * * * * * * * * * * * * * * *

EOF
perl -npe 's/#PrintMotd/PrintMotd/' -i /etc/ssh/sshd_config

# Restart ssh service
service sshd restart
