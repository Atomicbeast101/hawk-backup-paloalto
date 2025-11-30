#!/bin/sh

# Check required environment variables
for var in $REQUIRED_VARS; do
    if [ -z "$(eval echo \$$var)" ]; then
        echo "❌ ERROR: Required environment variable '$var' is not set."
        exit 1
    fi
done
echo "✅ All required environment variables are set."

# Setup .env environment
./setup.sh

# Configure cron schedule
echo "$CRON_SCHEDULE /app/run.sh >> /var/log/cron.log 2>&1" > /etc/crontabs/root

# Run cron in foreground
exec crond -f
