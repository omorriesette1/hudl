#! /bin/bash
NAME=$1
PASS=$2
EMAIL=$3
PHONE=$4

MYSQL="mysql -uroot -e"
${MYSQL}"Use User_Profiles; INSERT INTO profiles (id, username, password, email, phone) VALUES (NULL,'Payton', SHA1('bears'), 'wpayton@chicagobears.com', '555-134-3434')"
