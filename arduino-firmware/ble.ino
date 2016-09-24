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
BLEIntCharacteristic tempChar("180A", BLERead | BLENotify);
BLEIntCharacteristic lightChar("180B", BLERead | BLENotify);
BLEIntCharacteristic soundChar("180C", BLERead | BLENotify);

//Data Management
bool connected = false;
bool update = false;
int temp = -1;
int light = -1;
int sound = -1;

//Sets the current temp value being broadcast (1-10)
void setTemp(int t) {
  temp = t;
  update = true;
}

//Sets the current light value being broadcast (1-10)
void setLight(int l) {
  light = l;
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
void tick() {
  BLECentralHelper central = peripheral.central();
  if (central) {
    connected = true;
    if (update) {
      update = false;
      tempChar.setValue(temp);
      lightChar.setValue(light);
      soundChar.setValue(sound);
    }
  }
}

//Setup the BLE peripheral (should be done in the setup method)
void setupBLE() {
  peripheral.setLocalName("FlowBox");
  peripheral.setAdvertisedServiceUuid(dataService.uuid());
  peripheral.addAttribute(dataService);
  peripheral.addAttribute(tempChar);
  peripheral.addAttribute(lightChar);
  peripheral.addAttribute(soundChar);
  tempChar.setValue(-1);
  lightChar.setValue(-1);
  soundChar.setValue(-1);
}

//Begins broadcasting BLE signals
void beginBLEBroadcast() {
  peripheral.begin();
}

