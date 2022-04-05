FROM alpine:latest

RUN mkdir "logs" "backup-files" && touch /logs/cron.log
ARG DB_TO_RESTORE_CONNECTION=$DB_TO_RESTORE_CONNECTION
ARG DB_TO_DUMP_CONNECTION=$DB_TO_DUMP_CONNECTION
RUN printf "DB_TO_DUMP_CONNECTION=$DB_TO_DUMP_CONNECTION\nDB_TO_RESTORE_CONNECTION=$DB_TO_RESTORE_CONNECTION" > /tmp/env.sh
RUN apk add --no-cache postgresql-client
COPY --chmod=744 backup-transactions.sh /
COPY --chmod=644 backup-crontab /etc/cron.d/backup-crontab
RUN crontab /etc/cron.d/backup-crontab
ENTRYPOINT ["crond", "-f", "-l", "0"]
