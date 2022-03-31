FROM ubuntu:latest

RUN apt-get update
RUN apt-get install -y cron
COPY dwh-crontab /etc/cron.d/dwh-crontab
RUN chmod 0644 /etc/cron.d/dwh-crontab && crontab /etc/cron.d/dwh-crontab

# TODO install psql here
RUN apt-get install ...

COPY application-db-export/* /
COPY analytics-db-import/* /
RUN chmod +x /application_db_dump.sh
RUN chmod +x /analytics_db_import.sh

# saving the env files to /etc/environment before cron is started, TODO check if this is really needed
ENTRYPOINT ["/bin/sh", "-c", "printenv | grep -v \"no_proxy\" >> /etc/environment && cron -f"]