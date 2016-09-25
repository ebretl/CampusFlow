//
//  FlowBoxController.h
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface FlowBoxController : NSObject
@property (strong, nonatomic) CBService *service;
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *tempChar;
@property (strong, nonatomic) CBCharacteristic *soundChar;
@property (strong, nonatomic) CBCharacteristic *codeChar;
@property (strong, nonatomic) CBCharacteristic *devChar;
- (id)initWithPeripheral:(CBPeripheral*)peripheral;
+ (FlowBoxController*)instance;
+ (void)setFlowBox:(FlowBoxController*)fb;
@end
