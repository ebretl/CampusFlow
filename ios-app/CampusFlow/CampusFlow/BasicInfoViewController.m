//
//  BasicInfoViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "BasicInfoViewController.h"

@implementation BasicInfoViewController

- (IBAction)onSave:(id)sender {
    NSString *name = [self.nameField text];
    NSString *college = [self.collegeField text];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"CampusFlow_name"];
    [[NSUserDefaults standardUserDefaults] setValue:college forKey:@"CampusFlow_college"];
    [self.parentViewController dismissViewControllerAnimated:TRUE completion:nil];
}
@end
