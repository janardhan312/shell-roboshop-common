#!/bin/bash

source ./common.sh

check_root

dnf module disable redis -y &>>$LOG_FILE
VALIDATE $? "disable redis"

dnf module enable redis:7 -y &>>$LOG_FILE
VALIDATE $? "enbale new version"

dnf module install redis -y &>>$LOG_FILE
VALIDATE $? "Finally Installing redis"

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE $? "Allowing Remote connections"

systemctl enable redis &>>$LOG_FILE
VALIDATE $? "Enable redis"

systemctl start redis &>>$LOG_FILE
VALIDATE $? "Start redis"

Print_total_time