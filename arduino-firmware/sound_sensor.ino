
int raw_loudest = 500; //lower is more sensitive, <=1023

float sound_level(int pin) {
  long sum = 0;
  for(int i=0; i<64; i++) {
      sum += analogRead(pin);
  }

  int raw = sum >> 6;
  return (1023.0 - raw) / raw_loudest;
}

