# THORWallet - Backup of Data for Analytics
 This repository contains the configuration for running a cron job to back up the THORWallet backend data tables that are used for analytics and restore them in the analytics backend.
The backup is running on a digital ocean droplet.

## SSH Connection

For the connection you will need SSH key access that can be handled on Digital Ocean.
In your terminal connect the droplet via: `ssh root@{droplet-ipv4-address}`. After this you are connected to the droplets Linux console.
The ipv4 address of the droplet can be found on Digital Ocean.
Type ``exit`` to exit the droplets console.


## Transfer Files
To transfer the files in this repository to the droplet use the SCP protocol.


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
