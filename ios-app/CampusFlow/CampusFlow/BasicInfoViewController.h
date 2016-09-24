//
//  BasicInfoViewController.h
//  CampusFlow
//
//  Created by Ellie on 9/24/16.
//  Copyright © 2016 HackGT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicInfoViewController : UIViewController
- (IBAction)onSave:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *collegeField;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@end
