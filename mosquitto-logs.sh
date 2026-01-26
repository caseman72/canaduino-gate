#!/bin/bash
# Subscribe to gate MQTT debug logs

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SECRETS_FILE="$SCRIPT_DIR/secrets.yaml"

if [[ ! -f "$SECRETS_FILE" ]]; then
    echo "Error: secrets.yaml not found at $SECRETS_FILE"
    exit 1
fi

# Parse secrets from YAML
MQTT_BROKER=$(grep '^mqtt_broker:' "$SECRETS_FILE" | sed 's/mqtt_broker: *"//' | sed 's/"$//')
MQTT_USER=$(grep '^mqtt_username:' "$SECRETS_FILE" | sed 's/mqtt_username: *"//' | sed 's/"$//')
MQTT_PASS=$(grep '^mqtt_password:' "$SECRETS_FILE" | sed 's/mqtt_password: *"//' | sed 's/"$//')

TOPIC="${1:-gate/#}"

mosquitto_sub -h "$MQTT_BROKER" -p 8883 -u "$MQTT_USER" -P "$MQTT_PASS" -t "$TOPIC" --cafile /etc/ssl/cert.pem -v \
    | sed -e 's/\x1B\[[0-9;]*[a-zA-Z]//g'
