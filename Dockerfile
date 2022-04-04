# ----------------------------------------------------------------------------------------------------------------------------
# text file that provides a set of instructions to build a Docker image
# ----------------------------------------------------------------------------------------------------------------------------

# specify operation system
FROM ubuntu:latest



# download package information from all configured sources
RUN apt-get update



# ----------------------------------------------------------------------------------------------------------------------------
# create files and directories needed for backup-script
# ----------------------------------------------------------------------------------------------------------------------------
RUN mkdir "logs" "backup-files"
#RUN touch /backup-files/missions-db-tx_statistics-backup.dump /logs/dump.log /logs/restore.log /logs/procedure-calls.log /logs/cron.log
RUN touch /logs/cron.log

# ----------------------------------------------------------------------------------------------------------------------------
# create docker env variables for db connections
# ----------------------------------------------------------------------------------------------------------------------------
ENV DB_TO_DUMP_CONNECTION=$DB_TO_DUMP_CONNECTION
ENV DB_TO_RESTORE_CONNECTION=$DB_TO_RESTORE_CONNECTION

RUN echo "$DB_TO_DUMP_CONNECTION" "$DB_TO_RESTORE_CONNECTION"

# ----------------------------------------------------------------------------------------------------------------------------
# psql setup
# ----------------------------------------------------------------------------------------------------------------------------

# psql will be installed with all default settings
ARG DEBIAN_FRONTEND=noninteractive

# install psql
# -y causes apt to proceed without prompting for confirmation
RUN apt-get install -y postgresql postgresql-contrib

# copy needed files into docker image from directory into base directory ( / )
COPY /backup-transactions.sh /

# chmod allows to change permission on a file
# +x add permissions to script file and dont let cron run the script silently
RUN chmod +x /backup-transactions.sh && chmod 0744 /backup-transactions.sh

# ----------------------------------------------------------------------------------------------------------------------------
# cron setup
# ----------------------------------------------------------------------------------------------------------------------------

# install cron
RUN apt-get install cron

# write env variables to file to insert on crontab
RUN env > /tmp/env.sh

# copy text file with specified crons to the cron.d directory
COPY backup-crontab /etc/cron.d/backup-crontab

# Chmod 0644: sets permissions--> give execution rights on the cron job (https://chmodcommand.com/chmod-0644/)
RUN chmod 0644 /etc/cron.d/backup-crontab && crontab /etc/cron.d/backup-crontab

# Run the command on container startup
ENTRYPOINT cron && tail -f /logs/cron.log

#CMD env > /tmp/.MyApp.env && /bin/MyApp




