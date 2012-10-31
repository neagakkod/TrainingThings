//
//  LoanProfile.m
//  SaveCal
//
//  Created by user on 10/20/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "LoanProfile.h"
#import "CashFlowAnalyzer.h"

@implementation LoanProfile

//synthesizing

@synthesize loanAmount;
@synthesize paybackTime;
@synthesize equalPaymentAmount;

@synthesize dateStartPayments;
@synthesize dateFinishPayments;
@synthesize lPId;
@synthesize interestRate;
@synthesize compounding;
@synthesize paymentFrequency;

@synthesize name;


//-(int)paybackTime
//{
//   return  [self calculatePayBackTimeWithEffIntRate];
//}
-(double)calculateEffectiveInterestRate
{
    
    return  pow ( 1+(self.interestRate/(self.compounding*self.paymentFrequency)),self.compounding)-1;
    
}
-(int)calculatePayBackTime
{
    CashFlowAnalyzer* cfa=[CashFlowAnalyzer getInstance];
    
    
    int time =[cfa getTimeIntervalsNeeded_presentWorth:self.loanAmount interestRate:[self calculateEffectiveInterestRate] amount:self.equalPaymentAmount];
    NSLog(@"Number of payments needed:%i",time);
    
    return time;
    
}

-(int)calculatePayBackTimeWithEffIntRate

{
    CashFlowAnalyzer* cfa=[CashFlowAnalyzer getInstance];
   // double effectiveIntRate=
    
    int time =[cfa getTimeIntervalsNeeded_presentWorth:self.loanAmount interestRate:[self calculateEffectiveInterestRate] amount:self.equalPaymentAmount];
   NSLog(@"Number of payments needed:%i",time);
    
    return time;
}
-(BOOL)everythingIsFilled
{
    
    NSLog(@"loanAmount:%d",(self.loanAmount>0));
     NSLog(@"equalPayment:%d",(self.equalPaymentAmount>0));
     NSLog(@"interestRate:%d",(self.interestRate>0));
     NSLog(@"compouning:%d",(self.compounding>0));
    NSLog(@"payment frequency:%d",(self.paymentFrequency>0));
    
    return (self.loanAmount>0)&
           (self.equalPaymentAmount>0)&
           (self.interestRate>0)&
           (self.compounding>0)&
            (self.paymentFrequency>0);
}

-(double)calculateEqualPaymentAmount
{
      CashFlowAnalyzer* cfa=[CashFlowAnalyzer getInstance];
    
   return  [cfa getUniformCashFlowAmount_presentVal:self.loanAmount interestRate:self.interestRate timeInterval:self.paybackTime];
}

-(double)calculateEqualPaymentAmountWithEffIntRate
{
    CashFlowAnalyzer* cfa=[CashFlowAnalyzer getInstance];
    
    return  [cfa getUniformCashFlowAmount_presentVal:self.loanAmount interestRate:[self calculateEffectiveInterestRate] timeInterval:self.paybackTime];
}
-(LoanProfile*)initCreateLoanProfile_name:(NSString*)theName loanAmount:(double)theLoanAmount payBackTime:(int)thePayBackTime equalPaymentAmount:(double)theEqualPaymentAmount yearlyIntRate:(float)yearlyIntRate
{
    self.paymentFrequency=12;//this means 1/month payments
    self.compounding=1;//this means no compounding
    

    self= [super init];
    if (self)
    {
        self.interestRate=yearlyIntRate;
        self.equalPaymentAmount=theEqualPaymentAmount;
        self.paybackTime=thePayBackTime;
        //number of payments
        
        self.loanAmount=theLoanAmount;
        self.name=theName;
        
    }
    
    return self;
    
        
}

-(id)init
{
   self=  [super init];
    if (self)
    {
        
        self.paymentFrequency=12;//this means 1/month payments
        self.compounding=1;//this means no compounding

    }
    return self;
}
@end
