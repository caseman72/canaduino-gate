#!/bin/bash
# OTA upload script for gate-controller-test
# Uses secrets-test.h (separate HiveMQ cluster from production)
#
set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
DEVICE="${1:-gate-controller.local}"
CONFIG="${2:-gate-controller.yaml}"
SECRETS="${3:-secrets-test.h}"

/bin/bash "${SCRIPT_DIR}/upload.sh" "$DEVICE" "$CONFIG" "$SECRETS"
