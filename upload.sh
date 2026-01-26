#!/bin/bash
# OTA upload script for gate-controller

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEVICE="${1:-gate-controller.local}"
CONFIG="gate-controller.yaml"
SECRETS="$SCRIPT_DIR/secrets.h"

# Parse secrets.h and extract value (no escaping needed - quotes protect from shell)
parse_secret() {
    grep "#define $1 " "$SECRETS" | sed 's/.*"\(.*\)"/\1/'
}

if [[ ! -f "$SECRETS" ]]; then
    echo "Error: secrets.h not found. Copy secrets.example.h to secrets.h and fill in values."
    exit 1
fi

WIFI_PRIMARY_SSID=$(parse_secret WIFI_SSID_PRIMARY)
WIFI_PRIMARY_PASSWORD=$(parse_secret WIFI_PASSWORD_PRIMARY)
WIFI_SECONDARY_SSID=$(parse_secret WIFI_SSID_SECONDARY)
WIFI_SECONDARY_PASSWORD=$(parse_secret WIFI_PASSWORD_SECONDARY)
MQTT_BROKER=$(parse_secret MQTT_BROKER)
MQTT_USERNAME=$(parse_secret MQTT_USERNAME)
MQTT_PASSWORD=$(parse_secret MQTT_PASSWORD)
OTA_PASSWORD=$(parse_secret OTA_PASSWORD)

echo "Uploading to $DEVICE..."
cd "$SCRIPT_DIR"
esphome \
    -s wifi_primary_ssid "$WIFI_PRIMARY_SSID" \
    -s wifi_primary_password "$WIFI_PRIMARY_PASSWORD" \
    -s wifi_secondary_ssid "$WIFI_SECONDARY_SSID" \
    -s wifi_secondary_password "$WIFI_SECONDARY_PASSWORD" \
    -s mqtt_broker "$MQTT_BROKER" \
    -s mqtt_username "$MQTT_USERNAME" \
    -s mqtt_password "$MQTT_PASSWORD" \
    -s ota_password "$OTA_PASSWORD" \
    run "$CONFIG" --no-logs --device "$DEVICE"
