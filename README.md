# THORWallet - Transactions Backup
 This repository contains the configuration for running a cron job to back up the THORWallet backend transaction data and restore them in the analytics backend.


## Build and Run Docker Container

To build and run the docker container use

```
docker-compose up --build
```

skip the `--build`  flag to only run the dockerfile.



### Environment Variables

These environment variables are needed for the backup script to work correctly and establish a connection to the databases.

| Key                      | Type                 | Description                                                                                     |  
|--------------------------|----------------------|-------------------------------------------------------------------------------------------------|  
| DB_TO_DUMP_CONNECTION    | DB Connection String | String used to connect to db that is backed up                                                  |                                                                              
| DB_TO_RESTORE_CONNECTION | DB Connection String | String used to connect to db where backed-up data is restored |
