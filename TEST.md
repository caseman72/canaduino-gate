# Gate Controller Test Checklist

Manual test cases for gate-controller.yaml

## Prerequisites

- [ ] Device is powered with 12V (relays need 12V to actuate)
- [ ] Device connected to WiFi (check MQTT broker for connection)
- [ ] MQTT client ready to monitor `gate/sensor/gate_state/state`

## Input Wiring Check

- [ ] P1 (DI1) wired with 5V source feed
- [ ] P2 (DI2) wired with 5V source feed
- [ ] P4/Car Sensor (DI4) wired with 5V source feed

---

## P1 Basic Operation

### From CLOSED
- [ ] Press P1 → Gate state changes to OPENING
- [ ] Move relay (REL1) pulses ON for 1s
- [ ] After 15s → Gate state changes to OPEN
- [ ] After 60s → Gate state changes to CLOSING
- [ ] After 15s → Gate state changes to CLOSED

### From OPEN (before auto-close)
- [ ] Press P1 → Gate state changes to CLOSING
- [ ] After 15s → Gate state changes to CLOSED

---

## P1 STOP Behavior

### STOP while OPENING
- [ ] Press P1 while OPENING → Gate state changes to STOP
- [ ] Movement halts immediately
- [ ] Press P1 from STOP → Gate state changes to CLOSING
- [ ] Gate closes for same duration it was opening

### STOP while CLOSING
- [ ] Press P1 while CLOSING → Gate state changes to STOP
- [ ] Movement halts immediately
- [ ] Press P1 from STOP → Gate state changes to OPENING
- [ ] Gate opens for same duration it was closing

### Auto-close from STOP
- [ ] Leave gate in STOP state
- [ ] After 60s → Gate auto-closes
- [ ] If stopped while OPENING: closes for elapsed open time
- [ ] If stopped while CLOSING: closes for remaining close time

---

## P2 Latch Operation

### Latch from CLOSED
- [ ] Press P2 → Gate state changes to OPENING
- [ ] Latch relay (REL2) turns ON
- [ ] After 15s → Gate state changes to LATCHED_OPEN
- [ ] Gate stays open indefinitely (no auto-close)

### Unlatch from LATCHED_OPEN
- [ ] Press P2 → Gate state changes to CLOSING
- [ ] Latch relay (REL2) turns OFF
- [ ] Move relay (REL1) pulses ON for 1s
- [ ] After 15s → Gate state changes to CLOSED

### P1 from LATCHED_OPEN
- [ ] Press P1 while LATCHED_OPEN → Same as P2 (unlatch and close)

---

## P4 Car Sensor Operation

### From CLOSED
- [ ] Trigger P4 → Gate state changes to OPENING
- [ ] Latch relay (REL2) turns ON (passthrough)
- [ ] After 15s → Gate state changes to OPEN
- [ ] Auto-close timer does NOT start while P4 active

### P4 Release starts timer
- [ ] Release P4 while gate OPEN → 60s auto-close timer starts
- [ ] Latch relay (REL2) turns OFF

### P4 while OPEN
- [ ] Trigger P4 while OPEN → Resets 60s timer
- [ ] Release P4 → 60s timer starts fresh

### P4 while OPENING
- [ ] Trigger P4 while OPENING → Timer will start after opening completes
- [ ] Gate continues opening normally

### P4 while CLOSING (reversal)
- [ ] Trigger P4 while CLOSING → Gate reverses direction
- [ ] Gate state changes to OPENING
- [ ] Gate opens for same time it was closing
- [ ] Auto-close timer paused while P4 active

### P4 while STOP
- [ ] Trigger P4 while STOP → STOP state clears
- [ ] Gate treated as OPEN
- [ ] Timer paused while P4 active

---

## MQTT Controls

### Open Gate Button
- [ ] Publish "PRESS" to `gate/button/open_gate/command` → Same as P1

### Latch Gate Button
- [ ] Publish "PRESS" to `gate/button/latch_gate/command` → Same as P2

### State Monitoring
- [ ] `gate/sensor/gate_state/state` updates on all state changes
- [ ] States: CLOSED, OPENING, OPEN, STOP, CLOSING, LATCHED_OPEN

---

## Relay Indicators

- [ ] REL1 (Move) indicator lights when move relay active
- [ ] REL2 (Latch) indicator lights when latch relay active
- [ ] REL3-REL6 remain OFF at all times

---

## Timing Verification

- [ ] Gate move duration: 15 seconds
- [ ] Auto-close delay: 60 seconds
- [ ] Move relay pulse: 1 second

---

## Edge Cases

- [ ] Multiple rapid P1 presses handled gracefully
- [ ] P1 during OPENING then P1 during STOP reverses correctly
- [ ] P4 triggered then released during OPENING starts timer after open
- [ ] Power cycle returns to CLOSED state (no state restoration)

---

## Notes

_Record any issues or observations here:_

```
```
