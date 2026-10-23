#!/bin/bash
# OTA upload script for gate-controller
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEVICE="${1:-gate-controller.local}"  # 172.24.1.107 (3C:84:27:C3:C7:C4)
CONFIG="${2:-gate-controller.yaml}"
SECRETS="${3:-secrets.h}"

if [[ ! -f "$SCRIPT_DIR/$SECRETS" ]]; then
    echo "Error: ${SECRETS} not found. Copy secrets.example.h to ${SECRETS} and fill in values."
    exit 1
fi

# Parse secrets.h and extract value (no escaping needed - quotes protect from shell)
parse_secret() {
    grep "#define $1 " "$SCRIPT_DIR/$SECRETS" | sed 's/.*"\(.*\)"/\1/'
}

WIFI_SSID=$(parse_secret WIFI_SSID)
WIFI_PASSWORD=$(parse_secret WIFI_PASSWORD)
MQTT_BROKER=$(parse_secret MQTT_BROKER)
MQTT_USERNAME=$(parse_secret MQTT_USERNAME)
MQTT_PASSWORD=$(parse_secret MQTT_PASSWORD)
OTA_PASSWORD=$(parse_secret OTA_PASSWORD)

# Safety: refuse to flash an IP that isn't the gate controller (the old test
# board, MAC 3C:84:27:C2:F9:1C, is now revel-monitor). Uses the gate's retained
# MQTT IP report.
if [[ "$DEVICE" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    GATE_IP=$(mosquitto_sub -h "$MQTT_BROKER" -p 1883 -u "$MQTT_USERNAME" -P "$MQTT_PASSWORD" \
        -t gate/sensor/ip_address/state -C 1 -W 5 2>/dev/null || true)
    if [[ "$GATE_IP" != "$DEVICE" ]]; then
        echo "Error: $DEVICE is not the gate controller (MQTT reports gate at '${GATE_IP:-unknown}')."
        exit 1
    fi
fi

echo "Uploading to $DEVICE..."
cd "$SCRIPT_DIR"
esphome \
    -s wifi_ssid "$WIFI_SSID" \
    -s wifi_password "$WIFI_PASSWORD" \
    -s mqtt_broker "$MQTT_BROKER" \
    -s mqtt_username "$MQTT_USERNAME" \
    -s mqtt_password "$MQTT_PASSWORD" \
    -s ota_password "$OTA_PASSWORD" \
    run "$CONFIG" --no-logs --device "$DEVICE"
