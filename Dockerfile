# set of instructions to build a Docker image
FROM alpine
RUN apk update
RUN apk add --no-cache postgresql-client
RUN mkdir "logs" "backup-files"
# copy files and set permissions in separate statements to apply to DO dockerbuild kit
COPY  backup-transactions.sh /
COPY  env-script.sh /
COPY  backup-crontab /etc/cron.d/backup-crontab
RUN chmod 744 /backup-transactions.sh
RUN chmod 654 /env-script.sh
RUN chmod 644 /etc/cron.d/backup-crontab
RUN crontab /etc/cron.d/backup-crontab

# run intermdediate script to save and pass env vars
CMD /env-script.sh




