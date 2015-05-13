#!/usr/bin/env python

import MySQLdb
import socket

# Connect to the database
db = MySQLdb.connect(host='localhost', user='hudl', passwd='demo')
query = db.cursor()

# Configure variable queries
db_create = "CREATE DATABASE IF NOT EXISTS User_Profiles"

db_useUP = "USE User_Profiles"

table_create = "CREATE TABLE IF NOT EXISTS profiles (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, username VARCHAR(25), password VARCHAR(40), email VARCHAR(30), phone VARCHAR(20))"

table_insert = "INSERT INTO profiles (id, username, password, email, phone) VALUES (NULL,'Walter Payton', SHA1('bears'), 'wpayton@chicagobears.com', '555-134-3434'), (NULL, 'Barry Sanders', SHA1('lions'), 'bsanders@detroitlions.com', '555-120-2020'), (NULL, 'Earl Campbell', SHA1('oilers'), 'ecampbell@houstonoilers.com', '555-120-3434')"

db_configure = [db_create, db_useUP, table_create, table_insert]
db_base = [db_create, db_useUP, table_create]

# Setup hudl database for master and slave
if socket.gethostname() in ("prod-slave", "prod-master"):
    for tasks in db_configure:
	query.execute(tasks)
else:
    for tasks in db_base:
	query.execute(tasks)
