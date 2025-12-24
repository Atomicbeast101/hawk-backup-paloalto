# HawkBackup - PaloAlto Firewall Config Backup

Docker-based service that leverages Ansible to perform backups for Palo Alto firewall (PA-850, however it should work for PanOS-based devices) in my homelab.

## Requirements

* Palo Alto firewall with XML API enabled.
* Separate backup account (super admin account can be used, but highly adviced against) with the following permission:
    * `XML API` > `Configuration`

## How it Works

Whenever the cron schedule hits, it runs an Ansible playbook that does the following:
1) Create `/app/.downloads` folder.
2) Generates an API token from Palo Alto firewall.
3) Uses the API token to download the config from firewall onto `/app/.downloads` folder.
4) Uploads that config file to SFTP endpoint.
5) Removes the config file from `/app/.downloads`.
6) Checks SFTP endpoint for any old backups to remove.

If any of the tasks above fails, a Pushover notification will be sent stating that the backup failed for a specific firewall (by hostname).

## Setup - Docker

Here's an example of how to run this application in Docker:

```bash
docker run \
    -e FIREWALL_HOST=firewall.example.com \
    -e FIREWALL_USERNAME=backup \
    -e FIREWALL_PASSWORD=<password> \
    -e SFTP_HOST=sftp.example.com \
    -e SFTP_USERNAME=backup \
    -e SFTP_PASSWORD=<password> \
    -e SFTP_PATH="/path/to/directory" \
    -e PUSHOVER_USER_KEY=<user_key> \
    -e PUSHOVER_APP_TOKEN=<user_password> \
    ghcr.io/atomicbeast101/hawk-backup-paloalto:latest
```

More details on the environment variables can be found below.

## Environment Variables

| Environment Variable | Description | Default |
| :------- | :------ | :-------: |
| FIREWALL_HOST | FQDN/IP address of firewall to perform config backup. | N/A |
| FIREWALL_USERNAME | Username for firewall API access. | N/A |
| FIREWALL_PASSWORD | Password for firewall API access. | N/A |
| SFTP_HOST | FQDN/IP address of SFTP server to send downloaded config file to. | N/A |
| SFTP_PORT | Port of SFTP server. | 22 |
| SFTP_USERNAME | Username for SFTP server. | N/A |
| SFTP_PASSWORD | Password for SFTP server. | N/A |
| SFTP_PATH | Destination path in SFTP server to store config file in. | N/A |
| PUSHOVER_USER_KEY | User key for Pushover notifications. Gets sent out for failed backups. | N/A |
| PUSHOVER_APP_TOKEN | App token for Pushover notifications. Gets sent out for failed backups. | N/A |
| BACKUP_RETENTION_IN_DAYS | # of days to keep historical backups for. | 10 |
