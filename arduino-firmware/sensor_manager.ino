void start_recording() {
  
}

void stop_recording() {
  
}

void updateSensors() {
  recordSoundSecond();
  updateSoundVars();
  updateTemperature();

  setTemp(temperature());
  setDeviation(rollingSoundDeviation);
  setSound(rollingSoundAvg);
}
