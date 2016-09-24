
int milliAvg;
int milliPeak;

void recordMillisec() {
  unsigned long sum = 0;
  int count = 0;
  milliPeak = 0;
  unsigned long tStart = micros();
  unsigned long tEnd = tStart + 1000;
  while(micros() < tEnd) {
    int raw = analogRead(SOUND_PIN);
    sum += raw;
    count++;
    milliPeak = max(raw, milliPeak);
  }
  milliAvg = sum / count;
}

int soundAvg;
int soundPeakAvg;

//record average measurement and average peak value per millisecond
void recordSoundSecond() {
  unsigned long sum = 0;
  unsigned long peakSum = 0;
  int count = 0;
  unsigned long tStart = millis();
  unsigned long tEnd = tStart + 1000;
  while(millis() < tEnd) {
    recordMillisec();
    sum += milliAvg;
    peakSum += milliPeak;
    count++;
  }
  soundAvg = sum / count;
  soundPeakAvg = peakSum / count;
}

int getSoundAvg() {return soundAvg;}
int getSoundPeakAvg() {return soundPeakAvg;}




unsigned long soundTotal;
int soundIndex;
int soundArray [32];

void updateSound () {
  int newVal = analogRead(SOUND_PIN) * analogRead(SOUND_PIN);
  updateSoundAverage(newVal);
  updateSoundDeviation(newVal);
}

void updateSoundAverage(int newVal) {
  soundTotal += newVal;
  soundTotal -= soundArray[soundIndex];
  soundArray[soundIndex] = newVal;

  soundIndex = (soundIndex + 1) & 31;
  soundAverage = soundTotal >> 5;
}

unsigned long soundDevTotal;
int soundDevIndex;
int soundDevArray [32];

void updateSoundDeviation(int newVal) {
  newVal = (newVal - soundAverage) * (newVal - soundAverage);
  soundDevTotal += newVal;
  soundDevTotal -= soundDevArray[soundDevIndex];
  soundDevArray[soundDevIndex] = newVal;

  soundDevIndex = (soundDevIndex + 1) & 31;
  soundDeviation = sqrt((soundDevTotal >> 5));
}
