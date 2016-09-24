
const int trackingSeconds = 30;
const int measuresPerSecPower = 11;
const int measuresPerSec = 2048;
short soundArray [2048];

//record average measurement and average peak value per millisecond
//return number counted
void recordSoundSecond() {
  unsigned long tStart = micros();
  float microsPerMeasure = 1000000.0 / measuresPerSec;
  for(int i = 0; i < measuresPerSec; i++) {
    soundArray[i] = analogRead(SOUND_PIN);
    while(micros() < tStart + microsPerMeasure*i) { }
  }
}


int getSoundAvg() {
  unsigned long sum = 0;
  for(int i = 0; i < measuresPerSec; i++) {
    sum += soundArray[i];
  }
  return sum >> measuresPerSecPower;
}
unsigned long soundCurrTotal;
int soundCurrIndex;
int soundCurrArray [512];


int getSoundPeakAvg() {
  long sum = 0;
  for(int i = 0; i < measuresPerSec/32; i++) {
    int peak = 0;
    for(int j = 0; j < 32; j++) {
      peak = max(peak, soundArray[32*i+j]);
    }
    sum += peak;
  }
  return sum >> (measuresPerSecPower-5);
}

int getSoundAvgSqr() {
  unsigned long sum = 0;
  for(int i = 0; i < measuresPerSec; i++) {
    sum += soundArray[i] * soundArray[i];
  }
  return sqrt(sum >> measuresPerSecPower);
}

int getSoundDeviation(int avg) {
  unsigned long sum = 0;
  for(int i = 0; i < measuresPerSec; i++) {
    int n = (soundArray[i]-avg);
    sum += n*n;
  }
  return sqrt(sum >> measuresPerSecPower);
}





long sumOfAvgs;
int avgIndex;
int rollingAvgs [10];

long sumOfAvgsSqr;
int avgSqrIndex;
int rollingAvgsSqr [10];

float updateRollingAvg(int arr[], long *total, int *updateIndex, int newVal) {
  arr[updateIndex] = newVal;
  *total -= arr[*updateIndex];
  *total += newVal;

  len = sizeof(arr) / sizeof(arr[0]);
  *updateIndex = (*updateIndex + 1) & (len-1);
  return (float) *total / len;
}


