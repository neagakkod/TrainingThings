//
//  LoanProfile.h
//  SaveCal
//
//  Created by user on 10/20/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoanProfile : NSObject
@property (nonatomic) int lPId;
@property (nonatomic) double loanAmount;
@property (nonatomic) int paybackTime;
@property (nonatomic) double equalPaymentAmount;
@property (nonatomic) NSDate* dateStartPayments;
@property (nonatomic) NSDate* dateFinishPayments;
//interest Rate things
@property (nonatomic) float interestRate;//Yearly 
@property (nonatomic) int compounding;
@property (nonatomic) int paymentFrequency;//(ex every four month)

@property (nonatomic) NSString* name;

-(LoanProfile*)initCreateLoanProfile_name:(NSString*)name loanAmount:(double)loanAmount payBackTime:(int)payBackTime equalPaymentAmount:(double)equalPaymentAmount yearlyIntRate:(float)yearlyIntRate;
-(double) calculateEffectiveInterestRate;
-(int) calculatePayBackTime;
-(BOOL)everythingIsFilled;
-(int) calculatePayBackTimeWithEffIntRate;
-(double)calculateEqualPaymentAmount;
-(double)calculateEqualPaymentAmountWithEffIntRate;

@end
