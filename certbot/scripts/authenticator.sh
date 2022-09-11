#!/bin/sh

# Get your API key from https://www.cloudflare.com/a/account/my-account
API_KEY=$API_KEY
EMAIL="osamaabuhamdan@yahoo.com"

# Strip only the top domain to get the zone id
DOMAIN=$(echo $CERTBOT_DOMAIN | awk '{n=split($1, a, "."); printf("%s.%s", a[n-1], a[n])}')
# $(expr match "$CERTBOT_DOMAIN" '.*\.\(.*\..*\)')
# Get the Cloudflare zone id
echo $DOMAIN

ZONE_ID=$(curl -s -X GET "https://dns.hetzner.com/api/v1/zones?name=$DOMAIN" \
     -H     "Auth-API-Token:$API_KEY" \
     -H     "Content-Type:application/json" | python3 -c "import sys,json;print(json.load(sys.stdin)['zones'][0]['id'])")

# Create TXT record
CREATE_DOMAIN="_acme-challenge"
RECORD_ID=$(curl -s -X POST "https://dns.hetzner.com/api/v1/records" \
     -H     "Auth-API-Token: $API_KEY" \
     -H     "Content-Type: application/json" \
     --data '{"type":"TXT","name":"'"$CREATE_DOMAIN"'","value":"'"$CERTBOT_VALIDATION"'","ttl":120,"zone_id": "'"$ZONE_ID"'"}' \
             | python3 -c "import sys,json;print(json.load(sys.stdin)['record']['id'])")
# Save info for cleanup
if [ ! -d /tmp/CERTBOT_$CERTBOT_DOMAIN ];then
        mkdir -m 0700 /tmp/CERTBOT_$CERTBOT_DOMAIN
fi
echo $ZONE_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/ZONE_ID
echo $RECORD_ID > /tmp/CERTBOT_$CERTBOT_DOMAIN/RECORD_ID

# Sleep to make sure the change has time to propagate over to DNS
sleep 20
