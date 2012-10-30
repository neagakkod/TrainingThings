//
//  CashFlowAnalyzer.h
//  SaveCal
//
//  Created by user on 10/1/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CashFlowAnalyzer : NSObject
{
   @private
     CashFlowAnalyzer* singleton;
}

+(CashFlowAnalyzer*)getInstance;


/*
 this function is suppose to give out the amount of time needed in order to attend the equivalence of the 
 present worth at a certain interest rate and equal payments
 */
-(int)getTimeIntervalsNeeded_presentWorth:(double)presentWorth interestRate:(double)interestRate amount:(double)amount;
/*
 this function is suppose to give out the amount of time needed in order to attend the equivalence of the
 future worth at a certain interest rate and equal payments
 */
-(int)getTimeIntervalsNeeded_futureWorth:(double)futureWorth interestRate:(double)interestRate amount:(double)amount;

/*
 this function is suppose to give out the amount of time needed in order to attend the equivalence of the
 future worth at a certain interest rate and initial payments
 */
-(int)getTimeIntervalsNeeded_futureWorth:(double)futureWorth interestRate:(double)interestRate initial:(double)initial;


/*
 this function is will give out the amount of interest that has been gained in 
 (timeIntervalAtEnd-timeIntervalAtEnd) time 
 */
-(double)getUniformCashFlowGetInterest_interestRate: (double)interestRate amount:(double)amount timeIntervalAtEnd:(double)timeIntervalAtEnd timeIntervalSoFar:(double)timeIntervalSoFar;
/*
 this function will give you the amount of equal payments
 needed to amount to a future value with a given period time  and interest rate
 
 */
-(double)getUniformCashFlowAmount_futureVal:(double)futureValue interestRate:(double)interestRate timeInterval:(double)timeInterval;
/*
 this funciton gives the amount of equal payments
 that will be equivalent to the  present worth amount
 */

-(double)getUniformCashFlowAmount_presentVal:(double)presentValue interestRate:(double)interestRate timeInterval:(double)timeInterval;
/*
 this function will give you the future value given that you put equal payments for a period of time at
 
 */
-(double)getUniformCashFlowFutureValue_amount:(double)amount interestRate:(double)interestRate timeInterval:(double)timeInterval;

/*
 this function will give you the amount of equal payments
 needed to emulate to a present worth with a given period time  and interest rate
 ex: it could be used to calculate loans
 */
-(double)getUniformCashFlowPresentWorth_amount:(double)amount interestRate:(double)interestRate timeInterval:(double)timeInterval;
/*
 this function will give you the present worth of a given  future value  after a given period of time
 
 */

-(double)getSingleFormCashFlowPresentWorth_futureValue:(double)futureValue interestRate:(double)interestRate timeInterval:(double)timeInterval;

/*
 this function will give you the future value of a given present worth after a given period of time
 
 */
-(double)getSingleFormCashFlowFuture_presentValue:(double)presentValue interestRate:(double)interestRate timeInterval:(double)timeInterval;


@end
