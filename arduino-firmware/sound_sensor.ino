
int raw_loudest = 500; //lower is more sensitive, <=1023

float sound_level(int pin) {
  long sum = 0;
  for (int i = 0; i < 64; i++) {
    sum += analogRead(pin);
  }

  int raw = sum >> 6;
  return (1023.0 - raw) / raw_loudest;
}


unsigned long soundTotal;
int soundIndex;
int soundArray [512];

void updateSound () {
  int newVal = analogRead(SOUND_PIN) * analogRead(SOUND_PIN);
  updateSoundAverage(newVal);
  updateSoundDeviation(newVal);
}

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
