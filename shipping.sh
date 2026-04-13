#!/bin/bash

source ./common.sh
app_name=shipping


check_root
app_setup
java_setup
system_setup

dnf install mysql -y &>>$LOG_FILE
VALIDATE $? "installing mysql"


mysql -h mysql.devaws.icu -uroot -pRoboShop@1 < /app/db/schema.sql &>>$LOG_FILE
VALIDATE $? "schema" 

mysql -h mysql.devaws.icu -uroot -pRoboShop@1 < /app/db/app-user.sql &>>$LOG_FILE
VALIDATE $? "app user"

mysql -h mysql.devaws.icu -uroot -pRoboShop@1 < /app/db/master-data.sql &>>$LOG_FILE
VALIDATE $? "master data"



app_restart
Print_total_time