#!/usr/bin/env sh
#!/bin/bash

# check where the date command is located to avoid command not found error
date_command_location=$(command -v date)
startedTimestamp=$(${date_command_location} +%m-%d-%Y_%H:%M:%S)


# log message
echo "... starting backup for analytics data at ${startedTimestamp} ..."
# define dump file name
dumpFileName=/backup-files/missions-db-tx_statistics-backup.dump


echo "... dumping selected tables from missions-db ..."
# dump tx_statistics table from db and write errors in logs
pg_dump --data-only "$DB_TO_DUMP_CONNECTION" --format=custom  --table="tx_statistics" --table="address_watchlist" --table="mission_constraints_swap_single" --table="mission_constraints_swap_total" --table="address_rewards" --table="attempts"  --table="mission_rewards" --table="missions"> $dumpFileName  2> /logs/dump.log
# store error responses of pg_dump in variable for db insert later
dumpResponse=$(cat /logs/dump.log)


echo "... restoring selected data (tables) in analytics-db ..."
# before importing data dump tx_statistics table in analytics-db has to be cleared (truncated)
psql "$DB_TO_RESTORE_CONNECTION" -c 'TRUNCATE tx_statistics, address_watchlist, mission_constraints_swap_single, mission_constraints_swap_total, address_rewards, attempts, mission_rewards, missions'
# restore tx_statistics_table from dump and write
pg_restore --data-only -d "$DB_TO_RESTORE_CONNECTION"  --table="tx_statistics" --table="address_watchlist" --table="mission_constraints_swap_single" --table="mission_constraints_swap_total" --table="address_rewards" --table="attempts"  --table="mission_rewards" --table="missions"  < $dumpFileName 2> /logs/restore.log
# store error responses of pg_restore in variable for db insert later
restoreResponse=$(cat /logs/restore.log)


echo "... updating tables in analytics-db ..."
# call add_transactions to add transactions to analytics table
psql "$DB_TO_RESTORE_CONNECTION" -c 'CALL add_analytics_transactions()' 2> /logs/procedure-calls.log
# store error responses of db procedure calls in variable for db insert later
procedureCallsResponse=$(cat /logs/procedure-calls.log)


# define current timestamp
finishedTimestamp=$(${date_command_location} +%m-%d-%Y_%H:%M:%S)
echo "... inserting into backup_logs ..."
# insert logs into database
psql "$DB_TO_RESTORE_CONNECTION" -c "INSERT INTO backup_logs (started, finished, dumplogs, restorelogs, procedurecalllogs)
                                Values('$startedTimestamp', '$finishedTimestamp', '$dumpResponse', '$restoreResponse', '$procedureCallsResponse');"


echo "... finished backing up data for analytics at $finishedTimestamp!"
# empty lines at the end
echo
echo



