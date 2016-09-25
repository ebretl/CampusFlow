//
//  FirstViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "DashboardController.h"
#import "PBView.h"
#import "BLEManager.h"

@interface DashboardController ()

@end

@implementation DashboardController

static DashboardController *instance;

@synthesize flowboxStatus;

+ (DashboardController*) instance {
    return instance;
}

- (void)onConnectResult:(bool)result {
    if (result) {
        self.flowboxStatus.text = @"FlowBox Status: Connected";
    } else {
        self.flowboxStatus.text = @"FlowBox Status: Disconnected";
    }
}

- (void)changeDataWithTemp:(int)temp withDeviation:(int)dev withSound:(int)sound {
    
    [[NSUserDefaults standardUserDefaults] setInteger:temp forKey:@"CampusFlow_rec_temp"];
    [[NSUserDefaults standardUserDefaults] setInteger:dev forKey:@"CampusFlow_rec_dev"];
    [[NSUserDefaults standardUserDefaults] setInteger:sound forKey:@"CampusFlow_rec_sound"];
    
    [self.pbTemp setProgress:((double)temp - 65.0) / 15.0];
    
    int high = 250;
    int low = 50;
    double num = 10.0 / (double)(high - low);
    sound -= low;
    double progDev = (double)dev * num;
    double progSou = (double)sound * num;
    double avg = (progDev + progSou) / 2.0;
    double prog = (10.0 - (((double)((int)avg)))) / 10.0;
    [self.pbDash setProgress:prog];
}


static const CGSize progressViewSize = { 300.0f, 10.0f };

- (void)viewDidLoad {
    [super viewDidLoad];
    instance = self;
    [self.pbDash setFrame:CGRectMake(self.pbDash.frame.origin.x, self.pbDash.frame.origin.y, progressViewSize.width, progressViewSize.height)];
    [self.pbDash setTotal:10];
    [self.pbDash setMin:0];
    [self.pbDash setProgress:0.7];
    [self.pbTemp setFrame:CGRectMake(self.pbTemp.frame.origin.x, self.pbTemp.frame.origin.y, progressViewSize.width, progressViewSize.height)];
    [self.pbTemp setTotal:80];
    [self.pbTemp setMin:65];
    [self.pbTemp setProgress:5.0 / 15.0];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[[BLEManager instance] central] state];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"CampusFlow_welcome"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"complete" forKey:@"CampusFlow_welcome"];
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"viewWelcomeNav"] animated:TRUE completion:nil];
    } else {
        //[[BLEManager instance] connectToFlowBoxWithCode:(int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_BLE_code"]];
    }
}

- (void)onPairingComplete {
    [self dismissViewControllerAnimated:TRUE completion:^{
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"viewInfoNav"] animated:TRUE completion:nil];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
