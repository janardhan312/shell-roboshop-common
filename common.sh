USERID=$(id -u)
R="\e[31m"
G="\e[32m"
y="\e[33m"
N="\e[0m"

LOGS_FOLDER="/var/log/shell-roboshop"
SCRIPT_NAME=$( echo $0 | cut -d "." -f1 )
LOG_FILE="$LOGS_FOLDER/$SCRIPT_NAME.log"
START_TIME=$(date +%s)
SCRIPT_DIR=$PWD

mkdir -p $LOGS_FOLDER
echo "Script execute at: $(date)" | tee -a $LOG_FILE


check_root(){
    if [ $USERID -ne 0 ]; then
        echo "Error:: kindly run with the root user"
        exit 1
    fi
}


VALIDATE(){
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R Error $N" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$2 .... $G success $N"  | tee -a $LOG_FILE
    fi

}


nodejs_setup(){

    dnf module disable nodejs -y &>>$LOG_FILE
    VALIDATE $? "Disable nodejs"

    dnf module enable nodejs:20 -y &>>$LOG_FILE
    VALIDATE $? "enable nodejs:20"

    dnf install nodejs -y &>>$LOG_FILE
    VALIDATE $? "finally installing nodejs"

    npm install &>>$LOG_FILE
    VALIDATE $? "installing dependencys"

}



app_setup(){

        if id roboshop &>/dev/null; then
            echo -e "User already exists ----- $Y Skipping $N"
        else
            useradd --system --home /app --shell /sbin/nologin \
            --comment "roboshop system user" roboshop &>>$LOG_FILE

            VALIDATE $? "Creating user"
        fi



    mkdir -p /app 
    VALIDATE $? "creating directory"

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip &>>$LOG_FILE
    VALIDATE $? "downloading code into temp"

    cd /app 
    VALIDATE $? "changing to app directory"

    rm -rf /app/* 
    VALIDATE $? "removing old code"

    unzip /tmp/$app_name.zip &>>$LOG_FILE
    VALIDATE $? "file unzipping from temp to app directory"


}


system_setup(){
    cp $SCRIPT_DIR/$app_name.service /etc/systemd/system/$app_name.service
    VALIDATE $? "servicre code from service"

    systemctl daemon-reload
    VALIDATE $? "system reload"

    systemctl enable $app_name &>>$LOG_FILE
    VALIDATE $? "service enable"

}


app_restart(){
    systemctl restart $app_name
    VALIDATE $? "restart service"
}


Print_total_time(){
    END_TIME=$(date +%s)
    TOTAL_TIME=$((END_TIME - START_TIME))
    echo -e "script executed in: $Y $TOTAL_TIME $N"
}