//
//  LoanAdvancedViewController.h
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanProfile.h"
@interface LoanAdvancedViewController : UITableViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *timeUnitLabels;

@property (strong,nonatomic) IBOutlet UITextField*eqPaymentAmount;
@property (strong,nonatomic) IBOutlet UILabel* interestLabel;
@property (strong,nonatomic) IBOutlet UISlider* interestSlider;
@property (strong,nonatomic) IBOutlet UISegmentedControl*interestCompounding;
@property (strong,nonatomic) IBOutlet UISegmentedControl*paymentFrequency;
@property (strong,nonatomic) LoanProfile* lp;
-(IBAction)interestChangded :(id)sender;

-(IBAction)compoundingChanged:(id)sender;
-(IBAction)frequencyChanged:(id)sender;

@end
