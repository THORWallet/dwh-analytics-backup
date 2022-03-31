# dwh-cron-job
 This repository contains the configuration for running a cron job to back up the THORWallet backend transaction data in a docker container and restore them in the analytics backend.
It is deployed on a Digital Ocean droplet.


## Build and Run Docker Container
```
docker build -t dwh-cron-job

docker run dwh-cron-job
```



### Environment Variables

| Key                      | Type                 | Description                                                                                     |  
|--------------------------|----------------------|-------------------------------------------------------------------------------------------------|  
| DB_TO_DUMP_CONNECTION    | DB Connection String | String used to connect to db that is backed up                                                  |                                                                              
| DB_TO_RESTORE_CONNECTION | DB Connection String | String used to connect to db where backed-up data is restored |
