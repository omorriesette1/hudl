#! /bin/bash

# Edit hosts file
HOSTFILE="/etc/hosts"

# Edit hosts file
echo "172.168.50.10 prod-slave slave" >> ${HOSTFILE}
echo "172.168.50.20 hudl-dev dev" >> ${HOSTFILE}
