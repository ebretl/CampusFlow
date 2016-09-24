
float temperature(int pinTempSensor) {
  int B=4275;
  float a = analogRead(pinTempSensor ) * 3.3 / 5;
  
  //find resistance
  float R = 1023.0/((float)a)-1.0;
  R = 100000.0*R;
  
  //convert to temperature via datasheet
  float temperature=1.0/(log(R/100000.0)/B+1/298.15)-273.15;
  return temperature;
}

