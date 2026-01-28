#!/bin/bash
# OTA upload script for gate-controller-test
# Uses secrets-test.h (separate HiveMQ cluster from production)
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEVICE="${1:-172.24.1.168}"  # gate-controller-test (3C:84:27:C2:F9:1C)
CONFIG="${2:-gate-controller.yaml}"
SECRETS="${3:-secrets-test.h}"

/bin/bash "${SCRIPT_DIR}/upload.sh" "$DEVICE" "$CONFIG" "$SECRETS"
