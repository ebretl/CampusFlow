//
//  RecordViewController.m
//  CampusFlow
//
//  Created by Ellie on 9/25/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import "RecordViewController.h"
#import "RecordObject.h"
#import "HCSStarRatingView.h"

@implementation RecordViewController

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)onSubmit:(id)sender {
    if ([self.toggleSetting selectedSegmentIndex] == -1 ||
        [self.toggleLighting selectedSegmentIndex] == -1 ||
        [self.toggleFood selectedSegmentIndex] == -1 ||
        [self.toggleTraffic selectedSegmentIndex] == -1 ||
        [self.toggleWhiteboards selectedSegmentIndex] == -1 ||
        [self.toggleOutlets selectedSegmentIndex] == -1 ||
        [self.toggleTablespace selectedSegmentIndex] == -1 ||
        [self.textLocation.text isEqualToString:@""]) {
        UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Error" message:@"Please fill out all fields" preferredStyle:UIAlertControllerStyleAlert];
        [cont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:cont animated:TRUE completion:nil];
        return;
    }
    
    int sound = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_rec_sound"],
        dev = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_rec_sound"],
        temp = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_rec_sound"];
    
    RecordObject *record = [[RecordObject alloc] initWithSetting:[self.toggleSetting titleForSegmentAtIndex:self.toggleSetting.selectedSegmentIndex]
                                                    withLighting:[self.toggleLighting titleForSegmentAtIndex:self.toggleLighting.selectedSegmentIndex]
                                                        withFood:[self.toggleFood titleForSegmentAtIndex:self.toggleFood.selectedSegmentIndex]
                                                     withOutlets:[self.toggleOutlets titleForSegmentAtIndex:self.toggleOutlets.selectedSegmentIndex]
                                                 withWhiteboards:[self.toggleWhiteboards titleForSegmentAtIndex:self.toggleWhiteboards.selectedSegmentIndex]
                                                  withTablespace:[self.toggleTablespace titleForSegmentAtIndex:self.toggleTablespace.selectedSegmentIndex]
                                                     withTraffic:[self.toggleTraffic titleForSegmentAtIndex:self.toggleTraffic.selectedSegmentIndex]
                                                       withSound:sound
                                                         withDev:dev
                                                        withTemp:temp
                                                        withLocation:self.textLocation.text
                                                      withRating:self.ratingView.value];
    [RecordObject addRecord:record];
    self.textLocation.text = @"";
    [self.view endEditing:TRUE];
    UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Submitted" message:@"Record submitted. Thank you for using CampusFlow!" preferredStyle:UIAlertControllerStyleAlert];
    [cont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:cont animated:TRUE completion:nil];
}
@end
