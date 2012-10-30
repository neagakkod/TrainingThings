//
//  LoanDisplayViewController.h
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanProfile.h"

@interface LoanDisplayViewController : UITableViewController<UIScrollViewDelegate,UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel*totalPaymentPeriod;

@property (strong, nonatomic) IBOutlet UITextField *borrowedAmount;


@property (strong, nonatomic) IBOutlet UIScrollView *bottomScrollView;
@property (strong, nonatomic) IBOutlet UILabel *yearlyInterest;
@property (strong, nonatomic) IBOutlet UISlider *interestSlider;
@property (strong, nonatomic) IBOutlet UITextField *loanProfileName;
@property  (strong,nonatomic) LoanProfile *lp;

- (IBAction)sliderValueChanged:(id)sender;

- (IBAction)addPressed:(id)sender;


@end
