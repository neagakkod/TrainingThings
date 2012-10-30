//
//  SavingsAdvancedViewController.h
//  SaveCal
//
//  Created by user on 10/23/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SavingsProfile.h"
@interface SavingsAdvancedViewController : UITableViewController<UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *totalDepositsNeeded;
@property (strong,nonatomic) IBOutlet UITextField*eqDepositAmount;
@property (strong,nonatomic) IBOutlet
UILabel* interestLabel;
@property (strong,nonatomic) IBOutlet UISlider* interestSlider;
@property (strong,nonatomic) IBOutlet UISegmentedControl*interestCompounding;
@property (strong,nonatomic) IBOutlet UISegmentedControl*depositFrequency;
@property (strong,nonatomic) SavingsProfile*sp;
-(IBAction)interestChangded :(id)sender;
-(IBAction)depositChanged :(id)sender;
-(IBAction)compoundingChanged:(id)sender;
-(IBAction)frequencyChanged:(id)sender;
@end
