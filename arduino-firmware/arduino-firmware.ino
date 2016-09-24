#include <Wire.h>
#include "rgb_lcd.h"
//#include "thermal_sensor.c"

rgb_lcd lcd;

const int SOUND_PIN = A0;
const int TEMP_PIN = A2;

unsigned long millisTimer;

//user preferences currently resets for each session
float tempIdeal = 72;
float soundIdeal = 0; //not true

//space score weights (importance of being 1 unit from ideal value)
float weightTemp = 1.0;
float weightSound = 1.0;


void setup() {
  Serial.begin(9600);
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  lcd.setRGB(255, 255, 255);//set white backlight
  lcd.clear();

  //BLE
  setupBLE();
  beginBLEBroadcast();
}


void loop() {
  updateSensors();

  //lcd.print("Average: ");
  //lcd.print(soundCurrAverage);
  //lcd.print("       ");

  //lcd.setCursor(0, 1);
  //lcd.print(soundAverage);
  //lcd.print("       ");
  //lcd.setCursor(8, 1);  
  //lcd.print(soundDeviation);

  int avg = getSoundAvg();
  Serial.print(avg);
  Serial.print('\t');
  Serial.print(getSoundAvgSqr());
  Serial.print('\t');
  Serial.print(getSoundPeakAvg());
  Serial.print('\t');
  Serial.println(getSoundDeviation(avg));

  
  //BLE
  //tickBLE();
}

