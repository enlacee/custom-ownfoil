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

# Cargar las variables del archivo .env
if [ -f .env ]; then
  set -a
  source .env
  set +a
else
  echo "⚠️  Archivo .env no encontrado. Crea uno a partir de .env.dist"
  exit 1
fi


# CONFIGURA ESTO
API_TOKEN="$API_CLOUDFLARE_TOKEN"
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

echo ""
echo " ----------------------------------------------"
echo " --- Debuggin Data"
echo " --- Made by: https://blog.anibalcopitan.com"
echo " ----------------------------------------------"
echo ""
echo "API_TOKEN:" $API_TOKEN
echo "ZONE_ID:" $ZONE_ID
echo "RECORD_ID:" $RECORD_ID
echo "CURRENT_IP:" $CURRENT_IP
