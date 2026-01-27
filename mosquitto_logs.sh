#!/bin/bash
# Subscribe to gate MQTT debug logs

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SECRETS_FILE="$SCRIPT_DIR/secrets.h"

if [[ ! -f "$SECRETS_FILE" ]]; then
    echo "Error: secrets.h not found at $SECRETS_FILE"
    exit 1
fi

# Parse secrets from YAML
MQTT_BROKER=$(grep '^#define MQTT_BROKER ' "$SECRETS_FILE" | sed 's/#define MQTT_BROKER *"//' | sed 's/"$//')
MQTT_USER=$(grep '^#define MQTT_USERNAME ' "$SECRETS_FILE" | sed 's/#define MQTT_USERNAME *"//' | sed 's/"$//')
MQTT_PASS=$(grep '^#define MQTT_PASSWORD ' "$SECRETS_FILE" | sed 's/#define MQTT_PASSWORD *"//' | sed 's/"$//')

TOPIC="${1:-gate/#}"

mosquitto_sub -h "$MQTT_BROKER" -p 8883 -u "$MQTT_USER" -P "$MQTT_PASS" -t "$TOPIC" --cafile /etc/ssl/cert.pem -v \
    | sed -e 's/\x1B\[[0-9;]*[a-zA-Z]//g'
