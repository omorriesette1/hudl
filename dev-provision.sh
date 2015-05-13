#! /bin/bash

# Edit hosts file
HOSTFILE="/etc/hosts"

# Edit hosts file
echo "172.168.50.10 prod-slave slave" >> ${HOSTFILE}
echo "172.168.50.20 hudl-dev dev" >> ${HOSTFILE}

#Add scripts to path
echo "export PATH=$PATH:/home/vagrant/dev" >> /etc/bashrc
