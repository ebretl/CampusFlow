//
//  BLEManager.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "BLEManager.h"
#import "FlowBoxController.h"
#import "WelcomeViewController.h"

@implementation BLEManager

static BLEManager *statInstance;

+ (BLEManager*) instance {
    if (!statInstance)
        statInstance = [[BLEManager alloc] init];
    return statInstance;
}

CBPeripheral *discoveredPeripheral, *writingPeripheral;

NSMutableArray *buffer;

BOOL isSending = false;

@synthesize central, devices;

- (id)init {
    self = [super init];
    if (self) {
        self.devices = [[NSMutableArray alloc] init];
        self.central = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
        buffer = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)startScanningForDevices {
    [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"470A"]] options:nil];
}

- (void)stopScanning {
    [central stopScan];
}

- (BOOL)isBTEnabled {
    return [self.central state] == CBCentralManagerStatePoweredOn;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    
}

- (void)centralManager:(CBCentralManager *)ctrl didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Discovered FlowBox! Connecting...");
    discoveredPeripheral = peripheral;
    //[central stopScan];
    [central connectPeripheral:discoveredPeripheral options:@{CBConnectPeripheralOptionNotifyOnConnectionKey: @true}];
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"Connected to FlowBox! Discovering characteristics...");
    [discoveredPeripheral setDelegate:self];
    [discoveredPeripheral discoverServices:@[[CBUUID UUIDWithString:@"470A"]]];
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    FlowBoxController *bc = [[FlowBoxController alloc] initWithPeripheral:discoveredPeripheral];
    [bc setService:[self getServiceWithUUID:@"470A" fromPeripheral:discoveredPeripheral]];
    [self.devices addObject:bc];
    [discoveredPeripheral discoverCharacteristics:@[[CBUUID UUIDWithString:@"180A"], [CBUUID UUIDWithString:@"180C"], [CBUUID UUIDWithString:@"180D"]] forService:[bc service]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Peripheral connection failure: %@", error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    FlowBoxController *controller = [self getFlowBoxControllerForPeripheral:peripheral];
    for (CBCharacteristic *charac in [service characteristics]) {
        if ([[[charac UUID] UUIDString] isEqualToString:@"180A"]) {
            [controller setTempChar:charac];
        } else if ([[[charac UUID] UUIDString] isEqualToString:@"180C"]) {
            [controller setSoundChar:charac];
        } else if ([[[charac UUID] UUIDString] isEqualToString:@"180D"]) {
            [controller setCodeChar:charac];
        }
    }
    
    //FINISHED CONNECTING
    if ((int)[[controller codeChar] value] == self.code) {
        NSLog(@"Codes match!");
        [[WelcomeViewController instance] onConnectResult:true];
    } else {
        NSLog(@"Codes don't match!");
        [[WelcomeViewController instance] onConnectResult:true];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    
}

- (void)connectToFlowBoxWithCode:(int)code {
    self.code = code;
    [self startScanningForDevices];
}

- (FlowBoxController*)getFlowBoxControllerForPeripheral:(CBPeripheral*)peripheral {
    for (FlowBoxController *b in devices) {
        if ([[[b peripheral] identifier] isEqual:[peripheral identifier]])
            return b;
    }
    return nil;
}

- (CBService*)getServiceWithUUID:(NSString*)uuid fromPeripheral:(CBPeripheral*)peripheral {
    for (CBService *s in [peripheral services]) {
        if ([[s UUID] isEqual:[CBUUID UUIDWithString:uuid]])
            return s;
    }
    return nil;
}


@end
