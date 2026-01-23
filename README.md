# Gate Controller - ESPHome on Canaduino PLC

ESPHome-based gate controller running on an Arduino Nano ESP32 mounted on a Canaduino MEGA328 PLC-100 V2 board.

## Hardware

- **Controller:** [Canaduino MEGA328 PLC-100 V2 SMD](https://www.universal-solder.ca/product/canaduino-mega328-plc-100-v2-smd-for-arduino-nano/)
- **MCU:** Arduino Nano ESP32 v3
- **Framework:** ESP-IDF via ESPHome

### Pin Mapping

**Note:** Arduino Nano ESP32 uses different GPIO numbers than standard Arduino Nano.

| Function | Arduino Pin | GPIO | Direction |
|----------|-------------|------|-----------|
| P1 Remote Input | D7 | 10 | Input |
| P2 Remote Input | D8 | 17 | Input |
| Nexx Input | D13 | 48 | Input |
| Car Sensor | D12 | 47 | Input |
| Move Relay | D2 | 5 | Output |
| Latch Relay | D3 | 6 | Output |
| Unused Relay 3 | D4 | 7 | Output (held OFF) |
| Unused Relay 4 | D5 | 8 | Output (held OFF) |
| Unused Relay 5 | A2 | 3 | Output (held OFF) |
| Unused Relay 6 | A3 | 4 | Output (held OFF) |

### Relay Notes

- Relays are **active HIGH** (no inversion needed)
- PLC board handles relay driving - Nano just sends digital signals
- Relays are dry contacts (ground switching only)
- 12V power required for relays to actuate (USB power only lights indicators)

## Gate States

| State | Description |
|-------|-------------|
| CLOSED | Gate is closed |
| OPENING | Gate is opening (30s duration) |
| OPEN | Gate is open, 90s auto-close timer running |
| CLOSING | Gate is closing (30s duration) |
| LATCHED_OPEN | Gate is latched open indefinitely |

## Input Functions

### P1 (Remote Button 1)
- If gate is **LATCHED_OPEN**: Unlatch and close
- Otherwise: Open gate (with 90s auto-close)

### P2 (Remote Button 2) / Nexx
- Toggle latch state
- If **CLOSED**: Latch open
- If **LATCHED_OPEN**: Unlatch and close

### P4 (Car Sensor)
- Magnetic sensor that detects vehicles
- **ON**: Opens gate (via passthrough), stops auto-close timer
- **OFF**: Starts 90s auto-close timer
- Parking a car next to sensor keeps gate open indefinitely

## MQTT

### Broker
Uses HiveMQ Cloud with TLS on port 8883.

### Topics

**State:**
- `gate/sensor/gate_state/state` - Current gate state

**Controls:**
- `gate/button/open_gate/command` - Send "PRESS" to open
- `gate/button/latch_gate/command` - Send "PRESS" to toggle latch

**Relays (direct access):**
- `gate/switch/gate_latch/command` - "ON" or "OFF"
- `gate/switch/gate_move/command` - "ON" or "OFF"

### Home Assistant

MQTT discovery is enabled with prefix `homeassistant`. HA will auto-discover all entities when connected to the same broker.

HA MQTT configuration:
```yaml
mqtt:
  broker: <your-hivemq-broker>.s1.eu.hivemq.cloud
  port: 8883
  username: <username>
  password: <password>
  certificate: auto
```

## Setup

### 1. Install ESPHome

```bash
pip install esphome
```

### 2. Configure Secrets

Copy the example secrets file and fill in your values:

```bash
cp secrets.example.yaml secrets.yaml
```

Edit `secrets.yaml` with your WiFi and MQTT credentials.

### 3. First Flash (USB)

Connect the Nano ESP32 via USB and flash:

```bash
esphome run gate-controller.yaml
```

Select the USB/serial port when prompted.

### 4. OTA Updates

After initial flash, use OTA for updates:

```bash
./upload.sh
```

Or manually:

```bash
esphome run gate-controller.yaml --device gate-controller.local
```

## File Structure

```
canaduino-gate/
├── gate-controller.yaml    # Main ESPHome configuration
├── secrets.yaml            # WiFi/MQTT credentials (git-ignored)
├── secrets.example.yaml    # Template for secrets
├── upload.sh               # OTA upload script
├── README.md               # This file
└── .gitignore              # Git ignore rules
```

## Troubleshooting

### Floating Inputs
If inputs trigger randomly when not wired, the 100ms debounce filters should handle most noise. For bench testing without wiring, you can comment out the `binary_sensor` section.

### GPIO3 Warning
GPIO3 is a strapping pin on ESP32-S3. The warning can be ignored as the PLC board handles relay driving.

### No Web Interface
The web server is disabled in production to save resources. Use MQTT or physical inputs for control.

### OTA Fails
Ensure the device is on the same network and reachable at `gate-controller.local`. You can also use the IP address directly.

## License

MIT
