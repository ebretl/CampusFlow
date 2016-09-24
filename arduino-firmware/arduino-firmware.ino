#include <Wire.h>
#include "rgb_lcd.h"
//#include "thermal_sensor.c"

rgb_lcd lcd;
const int colorR = 255;
const int colorG = 255;
const int colorB = 255;

const int pinSound = A0;
const int pinLight = A1;
const int pinTherm = A2;


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
}

void loop() {
  //set the cursor to column 0, line 1
  // (note: line 1 is the second row, since counting begins with 0):
  lcd.setCursor(0, 1);
  // print the number of seconds since reset:
  lcd.print("Temp: ");
  lcd.println(temperature(pinTherm));
  delay(100);
}

