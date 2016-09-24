//
//  FlowBoxController.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "FlowBoxController.h"

@implementation FlowBoxController

@synthesize service, peripheral, tempChar, soundChar, codeChar;

- (id)initWithPeripheral:(CBPeripheral *)peripheral {
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
