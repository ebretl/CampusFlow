int averageTemperature;

int temperature() {
  return averageTemperature;
}

void updateTemperature () {
  int newVal = getRawTemperature();
  updateTempAverage(newVal);
}

int B=4275;

float getRawTemperature() {
  float a = analogRead(TEMP_PIN) * 3.3 / 5;
  
  //find resistance
  float R = 1023.0/((float)a)-1.0;
  R = 100000.0*R;
  
  //convert to temperature via datasheet
  float temperature=1.0/(log(R/100000.0)/B+1/298.15)-273.15;
  temperature *= 9/5.0;
  temperature += 32;
  return temperature;
}

unsigned long thermTotal;
int thermIndex;
int thermArray [64] ;

void updateTempAverage(int newVal) {
  thermTotal += newVal;
  thermTotal -= thermArray[thermIndex];
  thermArray[thermIndex] = newVal;
  
  thermIndex = (thermIndex + 1) & 63;
  averageTemperature = thermTotal >> 6;
}

