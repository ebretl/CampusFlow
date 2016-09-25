#include <BLEAttribute.h>
#include <BLECentral.h>
#include <BLECharacteristic.h>
#include <BLECommon.h>
#include <BLEDescriptor.h>
#include <BLEPeripheral.h>
#include <BLEService.h>
#include <BLETypedCharacteristic.h>
#include <BLETypedCharacteristics.h>
#include <BLEUuid.h>
#include <CurieBLE.h>

//BLE Management
BLEPeripheral peripheral;
BLEService dataService("470A");
BLEIntCharacteristic tempChar("924A", BLERead | BLENotify);
BLEIntCharacteristic deviationChar("924B", BLERead | BLENotify);
BLEIntCharacteristic soundChar("924C", BLERead | BLENotify);
BLEIntCharacteristic codeChar("924D", BLERead | BLENotify);

//Data Management
bool connected = false;
bool update = false;
int temp = -1;
int deviation = -1;
int sound = -1;

void setCode(int c) {
  code = c;
  update = true;
}

//Sets the current temp value being broadcast (1-10)
void setTemp(int t) {
  temp = t;
  update = true;
}

//Sets the current deviation value being broadcast (1-10)
void setDeviation(int l) {
  deviation = l;
  update = true;
}

//Sets the current sound value being broadcast (1-10)
void setSound(int s) {
  sound = s;
  update = true;
}

//Whether or not a central device has connected to the peripheral
bool isConnected() {
  return connected;
}

//Should be run on every tick of the Arduino in order to broadcast changed data to the peripheral
void tickBLE() {
  BLECentral center = peripheral.central();
  if (center) {
    connected = true;
    if (update) {
      update = false;
      tempChar.setValue(temp);
      deviationChar.setValue(deviation);
      soundChar.setValue(sound);
      codeChar.setValue(code);
    }
  }
}

//Setup the BLE peripheral (should be done in the setup method)
void setupBLE() {
  peripheral.setLocalName("FlowBox");
  peripheral.setAdvertisedServiceUuid(dataService.uuid());
  peripheral.addAttribute(dataService);
  peripheral.addAttribute(tempChar);
  peripheral.addAttribute(deviationChar);
  peripheral.addAttribute(soundChar);
  peripheral.addAttribute(codeChar);
  tempChar.setValue(-1);
  deviationChar.setValue(-1);
  soundChar.setValue(-1);

}

//Begins broadcasting BLE signals
void beginBLEBroadcast() {
  peripheral.begin();
  
  code += random(1, 10);
  code *= 10;
  code += random(0, 10);
  code *= 10;
  code += random(0, 10);
  code *= 10;
  code += random(1, 10);
  
  codeChar.setValue(code);

}

