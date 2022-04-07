#!/usr/bin/env sh
#!/bin/bash

echo "print connections"
echo "$DB_TO_RESTORE_CONNECTION"
echo "$DB_TO_DUMP_CONNECTION"



# ----------------------------------------------------------------------------------------------------------------------------
# script to dump transactions data from missions-db (tw-backend) to analytics-db (analytics-backend)
# ----------------------------------------------------------------------------------------------------------------------------

# check where the date command is located to avoid command not found error
date_command_location=$(command -v date)

# define starting timestamp
# shellcheck disable=SC2006
startedTimestamp=`${date_command_location} +%m-%d-%Y_%H:%M:%S`

# log message
echo "... Starting to backup transactions data at ${startedTimestamp} ..."


# ----------------------------------------------------------------------------------------------------------------------------
# define variables
# ----------------------------------------------------------------------------------------------------------------------------

# define dump file name
dumpFileName=/backup-files/missions-db-tx_statistics-backup.dump

# ----------------------------------------------------------------------------------------------------------------------------
# dump tx_statistics table from STAGE Mainnet tw-backend database
# ----------------------------------------------------------------------------------------------------------------------------

# log message
echo "... dumping tx_statistics from missions-db ..."

# dump tx_statistics table from db and write errors in logs
pg_dump --data-only "$DB_TO_DUMP_CONNECTION" --format=custom --table="tx_statistics"> $dumpFileName  2> /logs/dump.log

# store error responses of pg_dump in variable for db insert later
dumpResponse=$(cat /logs/dump.log)

# ----------------------------------------------------------------------------------------------------------------------------
# restore tx_statistics table from STAGE Mainnet tw-backend to analytics tx_statistics table
# ----------------------------------------------------------------------------------------------------------------------------


# log message
echo "... restoring transactions in analytics-db ..."

# before importing data dump tx_statistics table in analytics-db has to be cleared (truncated)
psql "$DB_TO_RESTORE_CONNECTION" -c 'TRUNCATE tx_statistics'

# restore tx_statistics_table from dump and write
pg_restore --data-only -d "$DB_TO_RESTORE_CONNECTION" -t tx_statistics  < $dumpFileName 2> /logs/restore.log

# store error responses of pg_restore in variable for db insert later
restoreResponse=$(cat /logs/restore.log)

# ----------------------------------------------------------------------------------------------------------------------------
# call functions to update transactions table in analytics-db that is used for analytics
# ----------------------------------------------------------------------------------------------------------------------------

# log message
echo "... updating tables in analytics-db ..."

# call add_transactions to add transactions to analytics table
psql "$DB_TO_RESTORE_CONNECTION" -c 'CALL add_analytics_transactions()' 2> /logs/procedure-calls.log

# store error responses of db procedure calls in variable for db insert later
procedureCallsResponse=$(cat /logs/procedure-calls.log)

# ----------------------------------------------------------------------------------------------------------------------------
# Insert log responses into database
# ----------------------------------------------------------------------------------------------------------------------------

# define current timestamp
finishedTimestamp=$(${date_command_location} +%m-%d-%Y_%H:%M:%S)


echo "... inserting /logs into backup_logs ..."

# insert logs into database
psql "$DB_TO_RESTORE_CONNECTION" -c "INSERT INTO backup_logs (started, finished, dumplogs, restorelogs, procedurecalllogs)
                                Values('$startedTimestamp', '$finishedTimestamp', '$dumpResponse', '$restoreResponse', '$procedureCallsResponse');"

# log message
echo "... finished backing up transactions data at $finishedTimestamp!"


