//
//  FilterRecommendationsViewController.h
//  CampusFlow
//
//  Created by Ellie on 9/25/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MultiSelectSegmentedControl.h"

@interface FilterRecommendationsViewController : UIViewController <NSURLConnectionDelegate, NSURLConnectionDataDelegate>
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *toggleSetting;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *toggleLighting;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *toggleTraffic;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *toggleFood;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *toggleOutlets;
@property (weak, nonatomic) IBOutlet UISegmentedControl *toggleWhiteboards;
@property (weak, nonatomic) IBOutlet MultiSelectSegmentedControl *toggleTableSpace;
- (IBAction)onSubmit:(id)sender;

+ (NSMutableArray*) getResults;
@end
