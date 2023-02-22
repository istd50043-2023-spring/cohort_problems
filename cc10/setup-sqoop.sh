#! /bin/bash 


flintrock copy-file --master-only  my-test-cluster testdb.sql /home/ec2-user/

# sudo yum update -y 
sudo rpm -Uvh https://dev.mysql.com/get/mysql57-community-release-el7-11.noarch.rpm 
sudo yum install -y mysql-community-server


sudo systemctl enable mysqld 
sudo systemctl start mysqld 
sudo grep 'temporary password' /var/log/mysqld.log

# we will see something like
# 2021-07-30T08:49:33.099261Z 1 [Note] A temporary password is generated for root@localhost: -EoesR<x)39d


mysql -u root -p 

mysql> ALTER USER 'root'@'localhost' IDENTIFIED BY 'mySql123$';
mysql> CREATE DATABASE testdb;


mysql -u root -p testdb < testdb.sql


