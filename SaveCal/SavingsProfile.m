//
//  SavingsProfile.m
//  SaveCal
//
//  Created by user on 10/22/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "SavingsProfile.h"
#import "CashFlowAnalyzer.h"

@implementation SavingsProfile

@synthesize sPId;
@synthesize savingsTime;
@synthesize startingWith;
@synthesize equalDepositAmount;
@synthesize dateStartDeposit;
@synthesize dateFinishDeposit;
@synthesize interestRate;
@synthesize compounding;
@synthesize depositFrequency;
@synthesize goal;
@synthesize name;

-(id)init
{
    self= [super init];
    if (self)
    {
        self.depositFrequency=12;//this means 1/month payments
        self.compounding=1;//this means no compounding
    }
    return  self;
}

-(SavingsProfile*)initCreateSavingsProfile_name:(NSString*)theName startingWith:(double)theStartingWith savingsTime:(int)theSavingsTime equalDepositAmount:(double)theEqualDepositAmount yearlyIntRate:(float)yearlyIntRate goal:(double)theGoal
{
    
    self.depositFrequency=12;//this means 1/month payments
    self.compounding=1;//this means no compounding
    
    
    self= [super init];
    if (self)
    {
        self.interestRate=yearlyIntRate;
        self.equalDepositAmount=theEqualDepositAmount;
        self.savingsTime=theSavingsTime;
        //number of payments
        
        self.startingWith=theStartingWith;
        self.name=theName;
        self.goal=theGoal;
    }
    
    return self;

}
-(double) calculateEffectiveInterestRate
{
    
    return  pow ( 1+(self.interestRate/(self.compounding*self.depositFrequency)),self.compounding)-1;

}
-(BOOL)everythingIsFilled
{
    return self.goal>0&self.equalDepositAmount>0&
           self.interestRate>0&self.compounding>0&
    self.depositFrequency>0;
}
-(int) calculateSavingsTimeWithEffIntRate
{
    CashFlowAnalyzer* cfa=[CashFlowAnalyzer getInstance];
    // double effectiveIntRate=
    
    int time =[cfa getTimeIntervalsNeeded_futureWorth:(self.goal-self.startingWith) interestRate:[self calculateEffectiveInterestRate] amount:self.equalDepositAmount];
    NSLog(@"Number of deposits needed:%i",time);
    
    return time;
}

-(double)calculateEqualDepositAmountWithEffIntRate
{
    
    CashFlowAnalyzer* cfa=[CashFlowAnalyzer getInstance];
    
    return  [cfa getUniformCashFlowAmount_futureVal:self.goal interestRate:[self calculateEffectiveInterestRate]  timeInterval:self.savingsTime];
}






@end
