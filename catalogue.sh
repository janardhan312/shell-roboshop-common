#!/bin/bash

source ./common.sh
app_name=catalogue


check_root
app_setup
nodejs_setup
system_setup

cp $SCRIPT_DIR/mongo.repo /etc/yum.repos.d/mongo.repo
VALIDATE $? "Copy mongo repo"

dnf install mongodb-mongosh -y &>>$LOG_FILE
VALIDATE $? "install mongdb client"

INDEX=$(mongosh mongodb.devaws.icu --quiet --eval "db.getMongo().getDBNames().indexOf('catalogue')")
if [ $INDEX -le 0 ]; then 
    mongosh --host mongodb.devaws.icu </app/db/master-data.js &>>$LOG_FILE   
    VALIDATE $? "loading products"
else 
    echo -e "products alredy loaded -----$Y Skipping $N"
fi

app_restart
Print_total_time