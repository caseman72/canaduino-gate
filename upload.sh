#!/bin/bash
# OTA upload script for gate-controller

DEVICE="${1:-gate-controller.local}"
CONFIG="gate-controller.yaml"

echo "Uploading to $DEVICE..."
esphome run "$CONFIG" --device "$DEVICE"
