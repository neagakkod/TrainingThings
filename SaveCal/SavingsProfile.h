//
//  SavingsProfile.h
//  SaveCal
//
//  Created by user on 10/22/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SavingsProfile : NSObject
@property (nonatomic) int sPId;
@property (nonatomic) double startingWith;
@property (nonatomic) int savingsTime;
@property (nonatomic) double equalDepositAmount;
@property (nonatomic) NSDate* dateStartDeposit;
@property (nonatomic) NSDate* dateFinishDeposit;
@property (nonatomic) double goal;
//interest Rate things
@property (nonatomic) float interestRate;//Yearly
@property (nonatomic) int compounding;
@property (nonatomic) int depositFrequency;//(ex every four month)

@property (nonatomic) NSString* name;

-(SavingsProfile*)initCreateSavingsProfile_name:(NSString*)name startingWith:(double)startingWith savingsTime:(int)savingsTime equalDepositAmount:(double)equalDepositAmount yearlyIntRate:(float)yearlyIntRate goal:(double)theGoal
;
-(double) calculateEffectiveInterestRate;
-(BOOL)everythingIsFilled;
-(int) calculateSavingsTimeWithEffIntRate;

-(double)calculateEqualDepositAmountWithEffIntRate;
@end
