
int raw_loudest = 500; //lower is more sensitive, <=1023

float sound_level(int pin) {
  long sum = 0;
  for (int i = 0; i < 64; i++) {
    sum += analogRead(pin);
  }

  int raw = sum >> 6;
  return (1023.0 - raw) / raw_loudest;
}


void updateSound () {
  int newVal = analogRead(SOUND_PIN) * analogRead(SOUND_PIN);
  updateCurrSoundAverage(newVal);
  if(millis() - millisTimer > 500) {
  updateSoundAverage(soundCurrAverage);
  millisTimer = millis();
  }
  updateSoundDeviation(soundCurrAverage);
}


unsigned long soundCurrTotal;
int soundCurrIndex;
int soundCurrArray [512];

void updateCurrSoundAverage(int newVal) {
  soundCurrTotal += newVal;
  soundCurrTotal -= soundCurrArray[soundCurrIndex];
  soundCurrArray[soundCurrIndex] = newVal;

  soundCurrIndex = (soundCurrIndex + 1) & 511;
  soundCurrAverage = soundCurrTotal >> 9;
}



unsigned long soundTotal;
int soundIndex;
int soundArray [512];

void updateSoundAverage(int newVal) {
  soundTotal += newVal;
  soundTotal -= soundArray[soundIndex];
  soundArray[soundIndex] = newVal;

  soundIndex = (soundIndex + 1) & 511;
  soundAverage = soundTotal >> 9;
}

unsigned long soundDevTotal;
int soundDevIndex;
int soundDevArray [512];

void updateSoundDeviation(int newVal) {
  newVal = (newVal - soundAverage) * (newVal - soundAverage);
  soundDevTotal += newVal;
  soundDevTotal -= soundDevArray[soundDevIndex];
  soundDevArray[soundDevIndex] = newVal;

  soundDevIndex = (soundDevIndex + 1) & 511;
  soundDeviation = sqrt((soundDevTotal >> 9));
}
