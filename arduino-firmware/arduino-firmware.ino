#include <Wire.h>
#include "rgb_lcd.h"
//#include "thermal_sensor.c"

rgb_lcd lcd;
const int colorR = 255;
const int colorG = 255;
const int colorB = 255;

const int SOUND_PIN = A0;
const int LIGHT_PIN = A1;
const int TEMP_PIN  = A2;



int soundAverage;
int soundDeviation;
//user preferences currently resets for each session
float tempIdeal = 72;
float soundIdeal = 0; //not true
float lightIdeal = 100; //idk what units this is

//space score weights (importance of being 1 unit from ideal value)
float weightTemp = 1.0;
float weightLight = 0.5;
float weightLound = 1.0;


void setup() {
  Serial.begin(9600);
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  lcd.setRGB(colorR, colorG, colorB);
  lcd.clear();
  //BLE
  setupBLE();
  beginBLEBroadcast();
}

void loop() {
  //set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  lcd.setCursor(0, 0);
  updateSensors();
  // print the number of seconds since reset:
  lcd.print("Average: ");
  lcd.print(soundAverage);
  
  lcd.setCursor(0, 1);
  lcd.print("Deviation: ");
  lcd.print(soundDeviation);
  

  //BLE
  tickBLE();
  
  delay(50);
}

