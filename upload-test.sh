#!/bin/bash
# OTA upload script for gate-controller-test
#
set -e

DEVICE="${1:-gate-controller-test.local}"
CONFIG="${2:-gate-controller-test.yaml}"

/bin/bash upload.sh "$DEVICE" "$CONFIG"
