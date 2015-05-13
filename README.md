AUTHOR: Orlando Morriesette
VERSION: 1


INSTRUCTIONS
============
1. Run "vagrant up" from the root vagrant directory (directory with Vagrant file)
2. Log into the master server (vagrant ssh master) using the credentials in the "implementation" section below
3. Run "demo -s" to begin replication setup
4. Run "demo -i "NAME" "PASS" "EMAIL" "PHONE"" to insert values into the database
5. Run "demo -b" To backup data on the slave, send to the dev machine, and sanitize the data
6. Run "demo -v" To verify all databases are in sync
7. Login to the dev machine with the credentials below and verify the database is properly updated

PROJECT SUMMARY
================
Having real user data in a test environment can speed up development. At Hudl we solve this problem
by automatically creating copies of the production datasets (properly scrubbed, of course) for use
in our test environment. For your project, we would like you to implement a simplified version of
this process.

1. Create at least two separate DB servers as virtual machines that would be your production and
test environments. The OS and database software can be your choice.

2. Create a simple ‘User Profiles’ database. Store a few basic attributes like username, hashed
password, email address and phone number. Add a few rows of dummy data so you can validate the
results. 

3. Schedule a database backup on an interval on the production server.

4. Automate restoring to the development server.

5. Be sure to sanitize the password, email addresses, and phone numbers.

6. Write a brief summary of how this implementation would be affected if the database were to grow
to 200 gigabytes.


IMPLEMENTATION
==============

- OS: Centos 6.6
- USER: vagrant
- PASSWORD: vagrant
- DATABASE: Mysql
- SERVERS: prod-master, prod-slave, hudl-dev
- BACKUP METHOD: Replication and mysqldump
- MACHINE SETUP: Vagrant
- NETWORK INTERFACES:
    -		      MASTER: BRIDGED, HOSTONLY (NET 192)
    -		      SLAVE: BRIDGED, HOSTONLY (NET 192), HOSTONLY (NET 172)
    -		      DEV: BRIDGED, HOSTONLY (NET 172)

MASTER:
-	~./ssh - SSH Keys
-	~/master/demo - Main Script

SLAVE:
-	~./.ssh - SSH Keys
-	~/slave/daily-backup - Daily backup script
-	~/slave/demo-slave - Replication script for slave
-	~/slave/hourly-backup - Hourly backup script

DEV: 
-	~/.ssh - SSH Keys
-	~/dev/restore-backup - Database scrub and restore script


This implementation uses a master and a slave. The slave has 2 types of backups, hourly and daily.
The hourly backups are for development and they are overwritten with each run. The daily backups
are compressed and moved into a separate folder for storing. This method has zero down time for the
master and gives the master redundancy. The development machine receives the backup and sanitizes the data for security purposes.

Due to the limited amount of time and small number of machines, I chose to use replication and
mysqldump as a backup method. Mysqldump is not ideal for very large databases due to the
significant speed degredation as data grows. Physical backups are usually the best way to go.
Another option would be to purchase commercial grade software like MYSQL Enterprise, or use a
master/slave environment where one of the slaves are taken offline periodically for backing up data. 

This is version 1 of this project and there are some improvements I would make if I had the time.
Below is a list of modifications I would make given the time:

1. Custom OS with setup and configurations baked into the image.
2. Increased security that includes a custom firewall and mysql configuration changes
3. Make all scripts more efficient
4. Add email status notifications for DEV backups with statistics of the data added
5. Fix any addtional bugs the script may have

