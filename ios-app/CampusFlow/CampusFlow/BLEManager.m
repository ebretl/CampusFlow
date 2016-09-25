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
#import "DashboardController.h"

@implementation BLEManager

static BLEManager *statInstance;

+ (BLEManager*) instance {
    if (!statInstance)
        statInstance = [[BLEManager alloc] init];
    [statInstance isBTEnabled];
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
    NSLog(@"Beginning to scan for bluetooth devices");
    [central scanForPeripheralsWithServices:@[[CBUUID UUIDWithString:@"470A"]] options:nil];
}

- (void)stopScanning {
    [central stopScan];
}

- (BOOL)isBTEnabled {
    return [self.central state] == CBCentralManagerStatePoweredOn;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"CBCentralManager state update");
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"CampusFlow_BLE_code"] != nil) {
        [[DashboardController instance] flowboxStatus].text = @"FlowBox Status: Connecting...";
        [[BLEManager instance] connectToFlowBoxWithCode:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_BLE_code"]];
    }
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
    NSLog(@"Discovered FlowBox services");
    FlowBoxController *bc = [[FlowBoxController alloc] initWithPeripheral:discoveredPeripheral];
    [bc setService:[self getServiceWithUUID:@"470A" fromPeripheral:discoveredPeripheral]];
    [self.devices addObject:bc];
    [discoveredPeripheral discoverCharacteristics:nil forService:[bc service]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Peripheral connection failure: %@", error);
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
    FlowBoxController *controller = [self getFlowBoxControllerForPeripheral:peripheral];
    for (CBCharacteristic *charac in [service characteristics]) {
        NSLog(@"Characteristic: %@", [charac UUID]);
        if ([[[charac UUID] UUIDString] isEqual:@"924A"]) {
            [controller setTempChar:charac];
        } else if ([[[charac UUID] UUIDString] isEqual:@"924B"]) {
            [controller setDevChar:charac];
        } else if ([[[charac UUID] UUIDString] isEqual:@"924C"]) {
            [controller setSoundChar:charac];
        } else if ([[[charac UUID] UUIDString] isEqual:@"924D"]) {
            NSLog(@"Found code char");
            [controller setCodeChar:charac];
        }
        [peripheral setNotifyValue:TRUE forCharacteristic:charac];
        [controller.peripheral readValueForCharacteristic:charac];
    }
    NSLog(@"Waiting for character read...");
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSData *data4 = [[characteristic value] subdataWithRange:NSMakeRange(0, 4)];
    int value = CFSwapInt32LittleToHost(*(int*)([data4 bytes]));
    //NSLog(@"%@: %i", [characteristic UUID], value);
    if ([[[characteristic UUID] UUIDString] isEqual:@"924D"] && value != 0) {
        [peripheral setNotifyValue:FALSE forCharacteristic:characteristic];
        FlowBoxController *controller = [self getFlowBoxControllerForPeripheral:peripheral];
        NSLog(@"Finished connecting");
        //FINISHED CONNECTING
        if (value == self.code) {
            NSLog(@"Codes match!");
            [[NSUserDefaults standardUserDefaults] setInteger:self.code forKey:@"CampusFlow_BLE_code"];
            [FlowBoxController setFlowBox:controller];
            [[WelcomeViewController instance] onConnectResult:true];
            [[DashboardController instance] onConnectResult:true];
        } else {
            NSLog(@"Codes don't match!");
            NSLog(@"Code: %i, Expected: %i", value, self.code);
            [[WelcomeViewController instance] onConnectResult:false];
            [[DashboardController instance] onConnectResult:true];
            [self.central cancelPeripheralConnection:controller.peripheral];
        }
    } else {
        [[DashboardController instance] changeDataWithTemp:[self getVal:[[FlowBoxController instance] tempChar]] withDeviation:[self getVal:[[FlowBoxController instance] devChar]] withSound:[self getVal:[[FlowBoxController instance] soundChar]]];
    }
}

- (int)getVal:(CBCharacteristic*) charac {
    if ([charac value] == nil) {
        return 0;
    }
    
    NSData *data4 = [[charac value] subdataWithRange:NSMakeRange(0, 4)];
    return CFSwapInt32LittleToHost(*(int*)([data4 bytes]));
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

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    NSLog(@"Peripheral disconnected");
    [FlowBoxController setFlowBox:nil];
    [[DashboardController instance] flowboxStatus].text = @"FlowBox Status: Disconnected";
}

- (CBService*)getServiceWithUUID:(NSString*)uuid fromPeripheral:(CBPeripheral*)peripheral {
    for (CBService *s in [peripheral services]) {
        if ([[s UUID] isEqual:[CBUUID UUIDWithString:uuid]])
            return s;
    }
    return nil;
}


@end
