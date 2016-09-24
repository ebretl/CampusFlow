//
//  FirstViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "FirstViewController.h"

@interface FirstViewController ()

@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"CampusFlow_welcome"] == nil) {
        [[NSUserDefaults standardUserDefaults] setValue:@"complete" forKey:@"CampusFlow_welcome"];
        [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"viewWelcomeNav"] animated:TRUE completion:nil];
    }
}

- (void)onPairingComplete {
    [self presentViewController:[self.storyboard instantiateViewControllerWithIdentifier:@"viewInfoNav"] animated:TRUE completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
