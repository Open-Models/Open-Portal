#!/bin/sh

CONFIG_FILE=open-portal.conf
CONFIG_FOLDER=/usr/share/portal/config

# Create let's encrypt certificate
if [ "$(command -v certbot)" ]
then
    CONFIG_FILE=open-portal-ssl.conf
    # Use --test-cert to avoid real certificate
    certbot certonly --standalone --test-cert -d $DOMAIN -m $MAIL --agree-tos -n
fi

# Set up configuration file
envsubst '${DOMAIN}' < $CONFIG_FOLDER/$CONFIG_FILE > /etc/nginx/conf.d/default.conf

nginx -g "daemon off;"
