#! /bin/bash

echo "----- HUDL DEMO BOOTSTRAP v1.0 -----"
# This file will simply make a few modifications on top of a base centos 6.6 image

# Ensure OS Packages are updated
echo "Updated OS Packages ..."
#yum -y update

# Install mysql
echo "Installing mysql ..."
yum -y install mysql

# Ensure we auto start mysql 
chkconfig mysqld on
chkconfig --list mysqld



# Create Hudl User
# Add Users
echo -n "Creating a hudl general user ...."
useradd hudl
usermod -p $(echo demo | openssl passwd -1 -stdin) hudl
echo "DONE"




# Add user to necessary groups
# Modify the sudoers file
echo "Giving hudl sudo privileges ...."
usermod -G wheel hudl
perl -npe 's/# %wheel/%wheel/' -i /etc/sudoers


# Customize MOTD
echo "Creating Dynamic MOTD ..."
cat << 'EOF' > /usr/local/bin/hudl-motd
PROCCOUNT=`ps -Afl | wc -l`
PROCCOUNT=`expr $PROCCOUNT - 5`
GROUPZ=`groups`
USER=`whoami`

ENDSESSION="Unlimited"
PRIVLAGED="Regular User"
Color_off='\e[0m'
#fi

echo -e "\033[1;32m

* * * * * * * * * * * * W A R N I N G * * * * * * * * * * * *
           THIS SYSTEM IS FOR DEMO PURPOSES ONLY!
* * * * * * * * * * * * W A R N I N G * * * * * * * * * * * *


\033[0;35m+++++++++++++++++: \033[0;37mSYSTEM DATA\033[0;35m :++++++++++++++++++++++
+  \033[0;37mHostname \033[0;35m= \033[1;32m`hostname`
\033[0;35m+   \033[0;37mAddress \033[0;35m= \033[1;32m`ifconfig eth0 | grep addr:[0-9] | awk '{print $2}' | cut -d: -f2`
\033[0;35m+    \033[0;37mKernel \033[0;35m= \033[1;32m`uname -r`
\033[0;35m+    \033[0;37mUptime \033[0;35m=\033[1;32m`uptime | sed 's/.*up ([^,]*),.*/1/'`
\033[0;35m+       \033[0;37mCPU \033[0;35m= \033[1;32m4x Intel(R) Xeon(R) E5620 @ 2.40GHz
\033[0;35m+    \033[0;37mMemory \033[0;35m= \033[1;32m`cat /proc/meminfo | grep MemTotal | awk '{print $2}'` kB
\033[0;35m++++++++++++++++++: \033[0;37mUSER DATA\033[0;35m :++++++++++++++++++++++++
+  \033[0;37mUsername \033[0;35m= \033[1;32m$USER
\033[0;35m+ \033[0;37mPrivlages \033[0;35m= \033[1;32m$PRIVLAGED
\033[0;35m+  \033[0;37mSessions \033[0;35m= \033[1;32m`who | grep $USER | wc -l` of $ENDSESSION MAX
\033[0;35m+ \033[0;37mProcesses \033[0;35m= \033[1;32m$PROCCOUNT of `ulimit -u` MAX
\033[0;35m++++++++++++++++++: \033[0;37mLAST LOGIN\033[0;35m :+++++++++++++++++++++++
+\033[0;37m \033[1;32m`lastlog -u $USER | grep $USER`
\033[0;35m++++++++++++++++++++++++++++++++
"
echo -e $Color_off
EOF
chmod +x /usr/local/bin/hudl-motd
echo "/usr/local/bin/hudl-motd" >> /etc/profile
