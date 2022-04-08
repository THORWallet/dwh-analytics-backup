
# THORWallet - Backup of Data for Analytics
This repository contains the configuration for running a cron job to back up the THORWallet backend data tables that are used for analytics and restore them in the analytics backend.  
The backup is running on a digital ocean droplet.

## Prerequisites

[Docker](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04) & [Docker Compose](https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-compose-on-ubuntu-20-04) have to be installed on the Digitial Ocean droplet.


## SSH Connection

For the connection you will need SSH key access that can be handled on Digital Ocean.  

In your terminal connect to the droplet via: 
`ssh root@159.223.231.26`

Type ``exit`` to exit the droplets console.


## Transfer Files
To transfer the files from this repository to the droplet use the SCP protocol:

`scp -r /path/to/this/repo/ root@159.223.231.26:/path/in/droplet`.

Use

```scp -r  dwh-analytics-backup root@159.223.231.26:```

to copy the folder to the `root` directory of the droplet.


## Build and Run Docker Container on the Droplet

While connected to the droplet console run
```  
docker compose up --build  
```  
in the folder with the docker-compose file to start the docker container running the backup-cron job (skip the `--build` flag to only run the dockerfile).

To list all the running docker containers in the console use ``docker ps``.

## Docker Volumes

Two Docker volumes are stored on the host-machine/droplet under `var/lib/docker/volumes`
They can also be found by using 

`docker volume ls`

There should be two docker volumes `backup-files` where the backup dump file is stored and `logs` where the logs are stored.
To inspect a volume use 

`docker volume inspect {volume_name}`

Note the volume name can be any identifier including numbers and other characters.


## Logs

All the logs are stored in the above-mentioned ```logs``` docker volume.
To read the logs use 

`cd var/lib/docker/volumes/dwh-analytics-backup_logs/_data`

and then `cat` the log file you want to inspect.


## Environment Variables

These environment variables are needed in an .env for the backup script to work correctly and establish a connection to the databases.

| Key                      | Type                 | Description                                                                                     |    
|--------------------------|----------------------|-------------------------------------------------------------------------------------------------|    
| DB_TO_DUMP_CONNECTION    | DB Connection String | String used to connect to db that is backed up                                                  |                                                                                
| DB_TO_RESTORE_CONNECTION | DB Connection String | String used to connect to db where backed-up data is restored |