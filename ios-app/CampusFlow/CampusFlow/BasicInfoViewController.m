//
//  BasicInfoViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "BasicInfoViewController.h"

@implementation BasicInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.nameField.delegate = self;
    self.collegeField.delegate = self;
}

- (IBAction)onSave:(id)sender {
    NSString *name = [self.nameField text];
    NSString *college = [self.collegeField text];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"CampusFlow_name"];
    [[NSUserDefaults standardUserDefaults] setValue:college forKey:@"CampusFlow_college"];
    if ([name isEqualToString:@""] || [college isEqualToString:@""]) {
        UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill out both fields" preferredStyle:UIAlertControllerStyleAlert];
        [cont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:cont animated:TRUE completion:nil];
    } else {
        [self.parentViewController dismissViewControllerAnimated:TRUE completion:nil];
    }
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
@end
