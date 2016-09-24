//
//  BLEManager.h
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BTStateListener.h"

@interface BLEManager : NSObject <CBCentralManagerDelegate, CBPeripheralDelegate>

- (BOOL)isBTEnabled;
- (void)startScanningForDevices;
- (void)stopScanning;
- (void)connectToFlowBoxWithCode:(int)code;

+ (BLEManager*)instance;

@property (strong, nonatomic) NSMutableArray *devices;
@property (strong, nonatomic) CBCentralManager *central;
@property (nonatomic) int code;

@end
