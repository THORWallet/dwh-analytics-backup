# set of instructions to build a Docker image
FROM alpine
RUN apk update
RUN apk add --no-cache postgresql-client
RUN mkdir "logs" "backup-files"
# copy files and set permissions
COPY --chmod=744 backup-transactions.sh /
COPY --chmod=654 env-script.sh /
COPY --chmod=644 backup-crontab /etc/cron.d/backup-crontab
RUN crontab /etc/cron.d/backup-crontab
# run intermdediate script to save and pass env vars
ENTRYPOINT /env-script.sh




