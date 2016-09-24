//
//  WelcomeViewController.h
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WelcomeViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIBarButtonItem *nextButton;
- (IBAction)onNextButtonPressed:(id)sender;
-(void) onConnectResult:(bool)result;
+ (WelcomeViewController*) instance;
@property (weak, nonatomic) IBOutlet UILabel *labelATitle;
@property (weak, nonatomic) IBOutlet UILabel *labelADesc;
@property (nonatomic) int stage;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end
