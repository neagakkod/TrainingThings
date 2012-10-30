//
//  SavingsViewController.h
//  SaveCal
//
//  Created by user on 10/23/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsProfile.h"

@interface SavingsViewController : UITableViewController
<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *totalSavingsPeriod;
@property (strong, nonatomic) IBOutlet UITextField *initialDeposit;
@property (strong, nonatomic) IBOutlet UITextField *goalAmount;
//@property (strong, nonatomic) IBOutlet UIScrollView *topScrollView;
@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong, nonatomic) IBOutlet UILabel *yearlyInterest;
@property (strong, nonatomic) IBOutlet UISlider *interestSlider;
@property (strong, nonatomic) IBOutlet UITextField *savingsProfileName;
@property  (strong,nonatomic) SavingsProfile *sp;


- (IBAction)sliderValueChanged:(id)sender;
//- (IBAction)generate:(id)sender;
- (IBAction)addOrSavePressed:(id)sender;
@end
