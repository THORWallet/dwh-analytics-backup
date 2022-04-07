#!/usr/bin/env sh
#!/bin/bash

# write env vars to file to pass to crontab
printenv | sed 's/^\(.*\)$/\1/g' > /tmp/env.sh

# check where the date command is located to avoid command not found error
date_command_location=$(command -v date)
cronStartTime=$(${date_command_location} +%m-%d-%Y_%H:%M:%S)
echo "start running cron at ${cronStartTime}:"
# run cron with output
crond -f -l 2

