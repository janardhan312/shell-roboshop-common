#!/bin/bash

source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Adding mongo repo"

dnf install mongodb-org -y &>>$LOG_FILE
VALIDATE $? "Installing Mongo DB"

systemctl enable mongod &>>$LOG_FILE
VALIDATE $? "Enable Mongo DB"

systemctl start mongod &>>$LOG_FILE
VALIDATE $? "Start Mongo DB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf
VALIDATE $? "Allowing Remote connections"

systemctl restart mongod 
VALIDATE $? "Restarted mongodb"

Print_total_time