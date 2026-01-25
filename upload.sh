#!/bin/bash
# OTA upload script for gate-controller

# Uncomment for verbose builds
#export ESPHOME_VERBOSE=true

DEVICE="${1:-gate-controller.local}"
CONFIG="gate-controller.yaml"

echo "Uploading to $DEVICE..."
esphome run "$CONFIG" --no-logs --device "$DEVICE"
