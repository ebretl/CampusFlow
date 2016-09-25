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

NSMutableData *connData2;

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)submitToOnline {
    NSMutableArray *params = [[NSMutableArray alloc] init];
        if (self.toggleSetting.selectedSegmentIndex == 0) {
            [params addObject:@"setting=indoor"];
        } else {
            [params addObject:@"setting=outdoor"];
        }
        switch(self.toggleLighting.selectedSegmentIndex) {
            case 0:
                [params addObject:@"brightness=bright"];
                break;
            case 1:
                [params addObject:@"brightness=medium"];
                break;
            case 2:
                [params addObject:@"brightness=dark"];
                break;
        }
    switch(self.toggleTraffic.selectedSegmentIndex) {
        case 0:
            [params addObject:@"traffic=high"];
            break;
        case 1:
            [params addObject:@"traffic=average"];
            break;
        case 2:
            [params addObject:@"traffic=empty"];
            break;
    }
    switch(self.toggleFood.selectedSegmentIndex) {
        case 0:
            [params addObject:@"food_nearby=shops/restaurants"];
            break;
        case 1:
            [params addObject:@"food_nearby=vending"];
            break;
        case -1:
            [params addObject:@"food_nearby=none"];
            break;
    }
    switch(self.toggleOutlets.selectedSegmentIndex) {
        case 0:
            [params addObject:@"outlets=many"];
            break;
        case 1:
            [params addObject:@"outlets=few"];
            break;
        case 2:
            [params addObject:@"outlets=none"];
            break;
    }
    switch(self.toggleTablespace.selectedSegmentIndex) {
        case 0:
            [params addObject:@"table_space=large"];
            break;
        case 1:
            [params addObject:@"table_space=small"];
            break;
        case 2:
            [params addObject:@"table_space=none"];
            break;
    }
    switch(self.toggleWhiteboards.selectedSegmentIndex) {
        case 0:
            [params addObject:@"whiteboards=yes"];
            break;
        case 1:
            [params addObject:@"whiteboards=no	"];
            break;
    }
    [params addObject:[NSString stringWithFormat:@"location=%@", [self.textLocation.text stringByReplacingOccurrencesOfString:@" " withString:@"+"]]];
    [params addObject:[NSString stringWithFormat:@"productivity_rating=%i", (int)self.ratingView.value]];
    [params addObject:[NSString stringWithFormat:@"temperature=%li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_rec_temp"]]];
    [params addObject:[NSString stringWithFormat:@"noise_level=%li", (long)[[NSUserDefaults standardUserDefaults] integerForKey:@"CampusFlow_rec_sound"]]];
    
    NSString *query = @"";
    for (NSString *para in params) {
        if (para) {
        query = [NSString stringWithFormat:@"%@%@&", query, para];
        }
    }
    if (query.length > 0) {
        query = [query substringToIndex:query.length - 1];
    }
    
    connData2 = [[NSMutableData alloc] init];
    NSLog(@"query = %@", query);
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"http://ec2-54-149-183-223.us-west-2.compute.amazonaws.com/submit.php?%@", query]];
    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestReloadRevalidatingCacheData timeoutInterval:5];
    NSLog(@"Calling %@", url);
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self startImmediately:TRUE];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [connData2 appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Finished submitting to cloud");
    UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Submitted" message:@"Record submitted to the cloud!" preferredStyle:UIAlertControllerStyleAlert];
    [cont addAction:[UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil]];

}

- (IBAction)onSubmit:(id)sender {
    if ([self.toggleSetting selectedSegmentIndex] == -1 ||
        [self.toggleLighting selectedSegmentIndex] == -1 ||
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
    RecordObject *record = nil;
    if (self.toggleFood.selectedSegmentIndex >= 0) {
    record = [[RecordObject alloc] initWithSetting:[self.toggleSetting titleForSegmentAtIndex:self.toggleSetting.selectedSegmentIndex]
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
    } else {
        record = [[RecordObject alloc] initWithSetting:[self.toggleSetting titleForSegmentAtIndex:self.toggleSetting.selectedSegmentIndex]
                                                        withLighting:[self.toggleLighting titleForSegmentAtIndex:self.toggleLighting.selectedSegmentIndex]
                                                            withFood:@"none"
                                                         withOutlets:[self.toggleOutlets titleForSegmentAtIndex:self.toggleOutlets.selectedSegmentIndex]
                                                     withWhiteboards:[self.toggleWhiteboards titleForSegmentAtIndex:self.toggleWhiteboards.selectedSegmentIndex]
                                                      withTablespace:[self.toggleTablespace titleForSegmentAtIndex:self.toggleTablespace.selectedSegmentIndex]
                                                         withTraffic:[self.toggleTraffic titleForSegmentAtIndex:self.toggleTraffic.selectedSegmentIndex]
                                                           withSound:sound
                                                             withDev:dev
                                                            withTemp:temp
                                                        withLocation:self.textLocation.text
                                                          withRating:self.ratingView.value];
    }
    [RecordObject addRecord:record];
    //self.textLocation.text = @"";
    [self.view endEditing:TRUE];
    UIAlertController *cont = [UIAlertController alertControllerWithTitle:@"Submitted" message:@"Record submitted. Thank you for using CampusFlow! Would you like to submit this information to the cloud?" preferredStyle:UIAlertControllerStyleAlert];
    [cont addAction:[UIAlertAction actionWithTitle:@"No Thanks" style:UIAlertActionStyleDefault handler:nil]];
    [cont addAction:[UIAlertAction actionWithTitle:@"Sure!" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self submitToOnline];
    }]];
    [self presentViewController:cont animated:TRUE completion:nil];
}
@end
