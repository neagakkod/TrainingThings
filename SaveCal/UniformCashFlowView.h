//
//  UniformCashFlowView.h
//  SaveCal
//
//  Created by user on 10/20/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoanProfile.h"
#import "SavingsProfile.h"
@interface UniformCashFlowView : UIView


@property (strong,nonatomic) UIBezierPath* moneyAxis;//aka y-axis
@property (strong, nonatomic)UIBezierPath* timeAxis;//aka x-axis
@property (strong,nonatomic) LoanProfile* lprofile;
@property(strong,nonatomic)  SavingsProfile*sprofile;
@property (nonatomic) int loan;
@property (nonatomic)double middleAxis;
@property (nonatomic)double xMargin;
@property (nonatomic)double yMargin;
@property (nonatomic) int currentimes;
@property (nonatomic) double lengthOfMoneyAxis;
@property (nonatomic) double lengthOfTimeAxis;
-(BOOL)needsToStrech;
-(void)drawEmptyGraph;
-(void)setMainProfile_profileType:(NSString*)profileType profile:(id)profile;
-(void)generateGraph_lendingAmount:(double)lendingAmount interestRate:(double)interestRate equalPaymentAmount:(double)equalPaymentAmount timeIntervals:(int)timeIntervals;
-(void)generateGraph_lendingAmount:(double)lendingAmount interestRate:(double)interestRate timeIntervals:(int)timeIntervals;
-(void)generateGraph_initialDeposit:(double)initialDeposit interestRate:(double)interestRate timeIntervals:(int)timeIntervals goal:(double)goal equalDepositAmount:(double)equalDepositAmount;
@end
