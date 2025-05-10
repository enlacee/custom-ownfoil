#!/bin/bash

# CONFIGURA ESTO
API_TOKEN="77soqtCoMWbwoz1yKYz-Y8gYwMp-17mIgtaYKfwU"
# API_TOKEN="TU_TOKEN"
ZONE_NAME="nintendomagica.com"
RECORD_NAME="foil.nintendomagica.com"

# Obtiene IP pública
IP=$(curl -s http://ipv4.icanhazip.com)

# Obtiene ID de zona
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$ZONE_NAME" \
     -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" | jq -r '.result[0].id')

# Obtiene ID del registro DNS
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$RECORD_NAME" \
    -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" | jq -r '.result[0].id')

# Actualiza el registro A
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$IP\",\"ttl\":120,\"proxied\":false}" > /dev/null



echo $ZONE_ID
echo " === "
echo $RECORD_ID
echo "IP =" . $IP
