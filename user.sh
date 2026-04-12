#!/bin/bash

source ./common.sh
app_name=user

check_root
app_setup
nodejs_setup
system_setup
app_restart
Print_total_time