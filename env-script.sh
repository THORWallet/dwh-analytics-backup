#!/usr/bin/env sh
#!/bin/bash

echo "env-script"

printenv

printenv | sed 's/^\(.*\)$/\1/g' > /tmp/env.sh
#printenv | grep -v "no_proxy" >> /etc/environment



echo "env.sh"
cat /tmp/env.sh

#echo "environment"
#cat /tmp/env.sh

echo "start cron"
cron -f && tail -f /logs/cron.log

