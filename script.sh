#!/bin/bash
# -----------------------------------------
# Script para actualizar IP pública en DNS
# Autor: Aníbal Copitán
# Blog: https://blog.anibalcopitan.com
# Fecha: 2025-05-12
# -----------------------------------------

#
# Config data on cloudflare with accound fakemail4x4 
# `nintendomagica.com`
#

# CONFIGURA ESTO
API_TOKEN="77soqtCoMWbwoz1yKYz-Y8gYwMp-17mIgtaYKfwU"
ZONE_NAME="nintendomagica.com"
RECORD_NAME="foil.nintendomagica.com"
IP_FILE="/tmp/last_ip.txt"

# Obtiene IP pública actual
CURRENT_IP=$(curl -s http://ipv4.icanhazip.com)

# Verifica si la IP cambió
if [ -f "$IP_FILE" ]; then
    LAST_IP=$(cat "$IP_FILE")
    if [ "$CURRENT_IP" == "$LAST_IP" ]; then
        echo "La IP no ha cambiado, no se actualiza. $CURRENT_IP"
        exit 0
    fi
fi

# Guarda nueva IP
echo "$CURRENT_IP" > "$IP_FILE"

# Obtiene ID de zona
ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones?name=$ZONE_NAME" \
     -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" | jq -r '.result[0].id')

# Obtiene ID del registro DNS
RECORD_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records?name=$RECORD_NAME" \
    -H "Authorization: Bearer $API_TOKEN" -H "Content-Type: application/json" | jq -r '.result[0].id')

# Actualiza el registro A en Cloudflare
curl -s -X PUT "https://api.cloudflare.com/client/v4/zones/$ZONE_ID/dns_records/$RECORD_ID" \
    -H "Authorization: Bearer $API_TOKEN" \
    -H "Content-Type: application/json" \
    --data "{\"type\":\"A\",\"name\":\"$RECORD_NAME\",\"content\":\"$CURRENT_IP\",\"ttl\":120,\"proxied\":false}" > /dev/null

echo "IP actualizada a $CURRENT_IP"

echo " --- Debuggin Data --- made by blo.anibalcopitan.com"
echo $ZONE_ID
echo " === "
echo $RECORD_ID
echo "IP =" . $IP
