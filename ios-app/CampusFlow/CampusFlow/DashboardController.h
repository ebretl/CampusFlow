//
//  FirstViewController.h
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PBView.h"

@interface DashboardController : UIViewController
@property (weak, nonatomic) IBOutlet PBView *pbDash;
@property (weak, nonatomic) IBOutlet PBView *pbTemp;
@property (weak, nonatomic) IBOutlet UILabel *flowboxStatus;

- (void)onPairingComplete;
- (void)onConnectResult:(bool)result;
+ (DashboardController*) instance;
- (void)changeDataWithTemp:(int)temp withDeviation:(int)dev withSound:(int)sound;
@end

