// Gate controller secrets
// Copy this to secrets.h and fill in your values
// secrets.h is gitignored

// Primary WiFi (default at boot)
#define WIFI_SSID_PRIMARY "your-primary-ssid"
#define WIFI_PASSWORD_PRIMARY "your-primary-password"

// Secondary WiFi (P3 toggles to this network)
#define WIFI_SSID_SECONDARY "your-secondary-ssid"
#define WIFI_PASSWORD_SECONDARY "your-secondary-password"

// MQTT broker (HiveMQ Cloud)
#define MQTT_BROKER "your-cluster.s1.eu.hivemq.cloud"
#define MQTT_USERNAME "your-mqtt-username"
#define MQTT_PASSWORD "your-mqtt-password"

// OTA password
#define OTA_PASSWORD "your-ota-password"
