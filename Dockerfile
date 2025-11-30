FROM alpine:3.22

# Dependencies
COPY packages.txt /tmp/packages.txt
RUN apk update && apk add --no-cache $(awk '{print $1}' /tmp/packages.txt)

# Environment Variables
ENV REQUIRED_VARS="FIREWALL_HOST FIREWALL_USERNAME FIREWALL_PASSWORD SFTP_HOST SFTP_USERNAME SFTP_PASSWORD SFTP_PATH PUSHOVER_USER_KEY PUSHOVER_APP_TOKEN"
ENV CRON_SCHEDULE="0 0 * * *"
ENV SFTP_PORT=22

# Start App
WORKDIR /app
COPY requirements.txt .
COPY requirements.yml .
COPY playbook.yml .
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh
VOLUME /var/log/cron
CMD ["/docker-entrypoint.sh"]
