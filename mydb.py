#!/usr/bin/env python

import MySQLdb
import socket

db = MySQLdb.connect(host='localhost', user='hudl', passwd='demo')
query = db.cursor()

db_create = "CREATE DATABASE IF NOT EXISTS User_Profiles"
db_useUP = "USE User_Profiles"
table_create = "CREATE TABLE IF NOT EXISTS profiles (id INT NOT NULL PRIMARY KEY AUTO_INCREMENT, username VARCHAR(25), password VARCHAR(40), email VARCHAR(30), phone VARCHAR(20))"
table_insert = "INSERT INTO profiles (id, username, password, email, phone) VALUES (NULL,'Walter Payton', SHA1('bears'), 'wpayton@chicagobears.com', '555-134-3434'), (NULL, 'Barry Sanders', SHA1('lions'), 'bsanders@detroitlions.com', '555-120-2020'), (NULL, 'Earl Campbell', SHA1('oilers'), 'ecampbell@houstonoilers.com', '555-120-3434')"

db_configure = [db_create, db_useUP, table_create, table_insert]

if socket.gethostname() in ("prod-slave", "prod-master"):
    for tasks in db_configure:
	query.execute(tasks)
