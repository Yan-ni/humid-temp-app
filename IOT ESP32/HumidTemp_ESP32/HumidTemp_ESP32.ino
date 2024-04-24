/*************             Libraries             *************/
#include <WiFi.h>
#include <DHT.h>
#include <Firebase_ESP_Client.h>
#include <string.h>
#include "addons/TokenHelper.h"
#include "time.h"

/*************             Constants             *************/
  #define DHT_PIN 4
  #define FAN_PIN 5
  #define RESET_WIFI_BUTTON 2
  #define DHT_TYPE DHT11
  // wifi
    #define WIFI_SSID "Bbox-A2B21140"
    #define WIFI_PASSWORD "6yuFtzKKW1yRdRzdwC"
    #define MAX_WIFI_CONNECTION_ATTEMPS 50
  // firebase
    #define API_KEY "AIzaSyDSoCGgpVO81Fpe83jTUSVFMW9isGNlfNQ"
    #define USER_EMAIL "testuser@gmail.com"
    #define USER_PASSWORD "password123"
    #define DATABASE_URL "https://humidtemp-1dc76-default-rtdb.europe-west1.firebasedatabase.app/" 
  // datetime
    #define PARIS_TIMEZONE "CET-1CEST-2,M3.5.0/02:00:00,M10.5.0/03:00:00"
    #define NTP_SERVER "pool.ntp.org"

/*************             Variables             *************/
  unsigned long previousMinute = 5;
  // dht captor variables
    DHT dht(DHT_PIN, DHT_TYPE);
  // firebase variables
    FirebaseData fbdo;
    FirebaseAuth auth;
    FirebaseConfig config;
    bool firebaseAuthOK = false;

  // wifi variables
    bool wifiOK = false;
    bool resetWifiPressed = LOW;
    bool resetWifiPressedPreviously = LOW;

void setup() {
  Serial.begin(115200);
  connect_wifi();
  init_firebase();
  dht.begin(); // init temperature/humidity captor
  configTzTime(PARIS_TIMEZONE, NTP_SERVER);
  pinMode (FAN_PIN, OUTPUT);
  pinMode (RESET_WIFI_BUTTON, INPUT);
}

void loop() {
  float temperature = dht.readTemperature();
  float humidity = dht.readHumidity();
  float threshold;
  struct tm timeinfo;

  check_reset_wifi();
  get_dht_data(&temperature, &humidity);
  get_threshold(&threshold);
  check_fan(temperature, threshold);
  save_humidTemp_data(temperature, humidity);

  getLocalTime(&timeinfo);
  int currentMinute = get_current_minute(&timeinfo);

  // executes every 5 minutes
  if (currentMinute % 5 == 0 && currentMinute != previousMinute) {
    previousMinute = currentMinute;

    char *temperaturePath, *humidityPath, *thresholdPath;
    get_paths(&timeinfo, &temperaturePath, &humidityPath, &thresholdPath);
    archive_humidTemp_data(temperaturePath, temperature, humidityPath, humidity, thresholdPath, threshold);
    free_paths(temperaturePath, humidityPath, thresholdPath);
  }

  delay(1000);
}

// Functions
void connect_wifi() {
  delay(1000);
  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Wifi connection attempt...");
  
  for(int i = 0; i < MAX_WIFI_CONNECTION_ATTEMPS; i++) {
    if(WiFi.status() == WL_CONNECTED) {
      Serial.println("Connection successful!");
      Serial.print("ip address: ");
      Serial.println(WiFi.localIP());
      wifiOK = true;
      return;
    }

    Serial.print(".");
    delay(100);
  }

  Serial.println("Connection failed!");
  wifiOK = false;
}

void init_firebase() {
  config.api_key = API_KEY;
  config.database_url = DATABASE_URL;

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  Firebase.reconnectWiFi(true);
  fbdo.setResponseSize(4096);

  config.token_status_callback = tokenStatusCallback;
  config.max_token_generation_retry = 5;

  Firebase.begin(&config, &auth);

  Serial.println("Getting User UID...");
  while ((auth.token.uid) == "") {
    Serial.print('.');
    delay(1000);
  }

  firebaseAuthOK = true;
}

void check_reset_wifi() {
  resetWifiPressed = digitalRead(RESET_WIFI_BUTTON);

  if (resetWifiPressed && !resetWifiPressedPreviously) {
    Serial.println("Reseting wifi...");
    connect_wifi();
    resetWifiPressedPreviously = true;
  }

  if (!resetWifiPressed) {
    resetWifiPressedPreviously = false;
  }
}

void get_dht_data(float *temperature, float *humidity) {
  *temperature = dht.readTemperature();
  *humidity = dht.readHumidity() / 100;

  if (isnan(*temperature) || isnan(*humidity))
    Serial.println("Failed to read from DHT sensor. Check the wiring.");

}

void get_threshold(float *threshold) {
  if(Firebase.ready() && firebaseAuthOK) {
    if (Firebase.RTDB.getFloat(&fbdo, "Threshold")) {
      if (fbdo.dataType() == "float" || fbdo.dataType() == "int") { // if the float a round number firebase converts it to an integer.
        *threshold = fbdo.floatData();
      }
    }
  }
}

void check_fan(const float temperature, const float threshold) {
  if(temperature >= threshold) {
    digitalWrite(FAN_PIN, HIGH);
  } else if (threshold - 2 >= temperature) {
    digitalWrite(FAN_PIN, LOW);
  }
}

void save_humidTemp_data(const float temperature, const float humidity) {
  // write humidity & temperature data to firebase.
  if(Firebase.ready() && firebaseAuthOK) {
    Firebase.RTDB.setFloat(&fbdo, "Temperature", temperature);
    Firebase.RTDB.setFloat(&fbdo, "Humidity", humidity);
  }
}

int get_current_minute(const struct tm *timeinfo) {
  char minuteStr[3];
  strftime(minuteStr,3, "%M", timeinfo);
  return atoi(minuteStr);
}

void get_paths(const struct tm *timeinfo, char **temperaturePath, char **humidityPath, char **thresholdPath) {
  int temperaturePathLen = 25 + 11 + 1, humidityPathLen = 25 + 8 + 1, thresholdPathLen = 25 + 9 + 1;

  *temperaturePath = (char *) malloc(temperaturePathLen);
  *humidityPath = (char *) malloc(humidityPathLen);
  *thresholdPath = (char *) malloc(thresholdPathLen);

  char pathBase[26];
  strftime(pathBase, 26, "Archive/%Y/%m/%d/%H:%M/", timeinfo);

  strcpy(*temperaturePath, pathBase);
  strcat(*temperaturePath, "Temperature");

  strcpy(*humidityPath, pathBase);
  strcat(*humidityPath, "Humidity");

  strcpy(*thresholdPath, pathBase);
  strcat(*thresholdPath, "Threshold");
}

void archive_humidTemp_data(const char *temperaturePath, const float temperature, const char *humidityPath, const float humidity, const char *thresholdPath, const float threshold) {
  if(Firebase.ready() && firebaseAuthOK) {
    // archive the temperature data.
    Firebase.RTDB.setFloat(&fbdo, temperaturePath, temperature);
    Firebase.RTDB.setFloat(&fbdo, humidityPath, humidity);
    Firebase.RTDB.setFloat(&fbdo, thresholdPath, threshold);
  }
}

void free_paths(char* temperaturePath, char* humidityPath, char* thresholdPath) {
  free(temperaturePath);
  free(humidityPath);
  free(thresholdPath);
}