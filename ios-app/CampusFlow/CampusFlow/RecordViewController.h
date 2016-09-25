//
//  RecordViewController.h
//  CampusFlow
//
//  Created by Ellie on 9/25/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface RecordViewController : UIViewController <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleSetting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleLighting;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleTraffic;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleFood;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleOutlets;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleWhiteboards;

@property (weak, nonatomic) IBOutlet UITextField *textLocation;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleTablespace;
- (IBAction)onSubmit:(id)sender;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@end
