#! /bin/bash

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
		mkdir -p /home/vagrant/backups
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
