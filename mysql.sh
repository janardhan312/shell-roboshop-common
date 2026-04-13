#!/bin/bash

source ./common.sh

check_root

dnf install mysql-server -y &>>LOG_FILE
VALIDATE $? "installing msql"

systemctl enable mysqld &>>LOG_FILE
systemctl start mysqld  
VALIDATE $? "Enable and starting msql server"


mysql_secure_installation --set-root-pass RoboShop@1 &>>LOG_FILE
VALIDATE $? "Setting root password"

Print_total_time
