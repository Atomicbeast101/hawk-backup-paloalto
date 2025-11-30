# HawkBackup - PaloAlto Firewall Config Backup

Docker-based service that leverages Ansible to perform backups for Palo Alto firewall (PA-850, however it should work for PanOS-based devices) in my homelab.

## How it Works

Docker container runs a cron job that will trigger an Ansible playbook that would access the switch to download the config into `/app/.downloads` folder, uploads it to SFTP endpoint, and deletes that local config file. Pushover notifications are sent if the Ansible playbook fails to download the config or upload it to SFTP endpoint.

## Setup

Once the environment variables are set (see below for details), run it via Docker-compatible environment such as Synology, Kubernetes, etc:
```bash
docker run adam/hawk-backup-paloalto:latest
```

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
