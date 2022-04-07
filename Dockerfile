# set of instructions to build a Docker image
FROM ubuntu:latest
# download package information from all configured sources
RUN apt-get update

# ----------------------------------------------------------------------------------------------------------------------------
# create files and directories needed for backup-script
# ----------------------------------------------------------------------------------------------------------------------------
RUN mkdir "logs" "backup-files"
ARG DEBIAN_FRONTEND=noninteractive

# install psql
# -y causes apt to proceed without prompting for confirmation
RUN apt-get install -y postgresql postgresql-contrib cron

# copy needed files into docker image from directory into base directory ( / )
COPY /backup-transactions.sh /
COPY /env-script.sh /

# chmod allows to change permission on a file
# +x add permissions to script file and dont let cron run the script silently
RUN chmod +x /backup-transactions.sh && chmod 0744 /backup-transactions.sh
RUN chmod +x /env-script.sh

# ----------------------------------------------------------------------------------------------------------------------------
# cron setup
# ----------------------------------------------------------------------------------------------------------------------------

# install cron
#RUN apt-get install cron

# write env variables to file to insert on crontab
RUN #env > /tmp/env.sh
#RUN echo /tmp/env.sh
#RUN $DB_TO_DUMP_CONNECTION  > /tmp/env.sh
#RUN $DB_TO_RESTORE_CONNECTION  >> /tmp/env.sh
#RUN cat /tmp/env.sh


# copy text file with specified crons to the cron.d directory
COPY backup-crontab /etc/cron.d/backup-crontab

# Chmod 0644: sets permissions--> give execution rights on the cron job (https://chmodcommand.com/chmod-0644/)
RUN chmod 0644 /etc/cron.d/backup-crontab && crontab /etc/cron.d/backup-crontab

#ENTRYPOINT ["/bin/sh", "-c", "printenv | grep -v \"no_proxy\" >> /etc/environment"]

# Run the command on container startup
#ENTRYPOINT cron && tail -f /logs/cron.log

#CMD env > /tmp/.MyApp.env && /bin/MyApp

ENTRYPOINT /env-script.sh




