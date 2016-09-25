#include <Wire.h>
#include "rgb_lcd.h"
//#include "thermal_sensor.c"

rgb_lcd lcd;

const int SOUND_PIN = A0;
const int TEMP_PIN = A2;

int soundAvg, soundAvgSqr, soundPeakAvg, soundDeviation;
int rollingSoundAvg, rollingSoundAvgSqr, rollingSoundPeakAvg, rollingSoundDeviation;

int code = 0;

//user preferences currently resets for each session
float tempIdeal = 72;
float soundIdeal = 0; //not true

//space score weights (importance of being 1 unit from ideal value)
float weightTemp = 1.0;
float weightSound = 1.0;

unsigned long buttonTimer;

int lowAmp = 50;
int highAmp = 250;

int lowDev = 50;
int highDev = 250;

// make some custom characters:
byte heart[8] = {
  0b00000,
  0b01010,
  0b11111,
  0b11111,
  0b11111,
  0b01110,
  0b00100,
  0b00000
};
byte degree[8] = {
  0b11100,
  0b10100,
  0b11100,
  0b00000,
  0b00000,
  0b00000,
  0b00000,
  0b00000
};

void setup() {
  Serial.begin(9600);
  // set up the LCD's number of columns and rows:
  lcd.begin(16, 2);
  lcd.setRGB(255, 255, 255);//set white backlight
  lcd.clear();
  lcd.createChar(0, heart);
  lcd.createChar(1, degree);
  randomSeed(analogRead(0) + analogRead(1) + analogRead(2) + analogRead(3) + analogRead(4));

  attachInterrupt(2, buttonHandler, CHANGE);

  recordSoundSecond();
  for (int i = 0; i < 500; i++) {
    updateTemperature();
    updateSoundVars();
  }

  //BLE
  setupBLE();
  beginBLEBroadcast();
}

void loop() {
  updateSensors();

  int score = (constrain(map(rollingSoundAvg, lowAmp, highAmp, 0, 10), 0, 10) + constrain(map(rollingSoundDeviation, lowDev, highDev, 0, 10), 0, 10)) / 2;
  score = 10 - score;

  if (millis() - buttonTimer < 2000) {
    lcd.setCursor(0, 0);
    lcd.print("Pair Code:                ");
    lcd.setCursor(0, 1);
    lcd.print(code);
    lcd.print("           ");
  }
  else {
    lcd.setCursor(0, 0);
    lcd.print("FlowBox     ");
    lcd.print(temperature());
    lcd.write(1);
    lcd.print("F       ");
    lcd.print(rollingSoundAvg);

    lcd.setCursor(0, 1);
    for (int i = 0; i < score; i++) {
      lcd.write(byte(0));
    }
    lcd.print("           ");
  }

  int avg = getSoundAvg();
  Serial.print(avg);
  Serial.print('\t');
  Serial.print(getSoundAvgSqr());
  Serial.print('\t');
  Serial.print(getSoundPeakAvg());
  Serial.print('\t');
  Serial.println(getSoundDeviation(avg));


  //BLE
  tickBLE();
}

void buttonHandler() {
  buttonTimer = millis();
}
