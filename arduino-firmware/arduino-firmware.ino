#include <Wire.h>
#include "rgb_lcd.h"
//#include "thermal_sensor.c"

rgb_lcd lcd;

const int SOUND_PIN = A0;
const int TEMP_PIN = A2;

int soundAverage;
int soundDeviation;
//user preferences currently resets for each session
float tempIdeal = 72;
float soundIdeal = 0; //not true
float lightIdeal = 100; //idk what units this is

//space score weights (importance of being 1 unit from ideal value)
float weightTemp = 1.0;
float weightLight = 0.5;
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
  lcd.setCursor(0, 0);
  updateSensors();
  lcd.print("Average: ");
  lcd.print(soundAverage);
  
  lcd.setCursor(0, 1);
  lcd.print("Deviation: ");
  lcd.print(soundDeviation);
  

  //BLE
  tickBLE();
  
  delay(10);
}

