//
//  CashFlowAnalyzer.m
//  SaveCal
//
//  Created by user on 10/1/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "CashFlowAnalyzer.h"
@interface CashFlowAnalyzer(private)

-(double)getSingleFormCashFlowPFuturePresentGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval;//f/p
-(double)getSingleFormCashFlowPresentWorthFutureGiven_interestRate :(double)interestRate timeInterval:(double)timeInterval;//(p/f
-(double)getUniformCashFlowAmountPresentGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval;//a/p
-(double)getUniformCashFlowPresentWorthAmountGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval;//p/a
-(double)getUniformCashFlowFutureValueAmountGiven_interestRate :(double)interestRate timeInterval:(double)timeInterval;//f/a

@end
@implementation CashFlowAnalyzer


+(CashFlowAnalyzer*) getInstance
{
    static CashFlowAnalyzer* theSignleton = nil;
    
    @synchronized([self class])
    {
        if (theSignleton == nil)
        {
            theSignleton = [[CashFlowAnalyzer alloc] init];
        }
    }
    return theSignleton;
}


/*
 this function is suppose to give out the amount of time needed in order to attend the equivalence of the
 present worth at a certain interest rate and equal payments
 */
-(int)getTimeIntervalsNeeded_presentWorth:(double)presentWorth interestRate:(double)interestRate amount:(double)amount
{
   
    double result=0;
    double worthAtTime;
    do
    {
        
        result++;
         worthAtTime=[self getUniformCashFlowPresentWorth_amount:amount interestRate:interestRate timeInterval:result];
        NSLog(@"worthAtTime:%f",(worthAtTime));
        NSLog(@"resentWorth-worthAtTime:%f",(presentWorth-worthAtTime));
    } while ((presentWorth-worthAtTime)>0);
    
   
    //result--;
    
    
    return (int)result;
    
    
    
}

/*
 this function is suppose to give out the amount of time needed in order to attend the equivalence of the
 future worth at a certain interest rate and equal payments
 */
-(int)getTimeIntervalsNeeded_futureWorth:(double)goal interestRate:(double)interestRate amount:(double)amount
{
    
    double result=0;
    double fworthAtTime;
    do
    {
        result++;
        fworthAtTime=[self getUniformCashFlowFutureValue_amount:amount interestRate:interestRate timeInterval:result];
        
        
        NSLog(@"worthAtTime:%f",(fworthAtTime));
        NSLog(@"resentWorth-worthAtTime:%f",(goal-fworthAtTime));
        
        
    } while ((goal-fworthAtTime)>0);
    
    
    result--;
    
    
    return (int)result;
    
}
/*
 this function is suppose to give out the amount of time needed in order to attend the equivalence of the
 future worth at a certain interest rate and one initial payments
 */

-(int)getTimeIntervalsNeeded_futureWorth:(double)goal interestRate:(double)interestRate initial:(double)initial
{
    double result=0;
    double fworthAtTime;
    do
    {
                result++;
     
        fworthAtTime= [self getSingleFormCashFlowFuture_presentValue:initial interestRate:interestRate timeInterval:result];
        
        NSLog(@"worthAtTime %i:%f",(int)result,(fworthAtTime));
        NSLog(@"goal-worthAtTime:%f",(goal-fworthAtTime));
        
        
    } while ((goal-fworthAtTime)>0);
    
    
    result--;
    
    
    return (int)result;

}



/*
 this function is will give out the amount of interest that has been gained in:
 (timeIntervalAtEnd-timeIntervalAtEnd) periods of time.
 */
-(double)getUniformCashFlowGetInterest_interestRate: (double)interestRate amount:(double)amount timeIntervalAtEnd:(double)timeIntervalAtEnd timeIntervalSoFar:(double)timeIntervalSoFar

{
    double time=(timeIntervalAtEnd-timeIntervalSoFar)+1;
    NSLog(@"the principal:%f",[self getUniformCashFlowPresentWorth_amount:amount interestRate:interestRate timeInterval:time]); //get :amount interestRate:interestRate timeInterval:time]);
    NSLog(@"the interest rate:%f ",interestRate);
    return [self getUniformCashFlowPresentWorth_amount:amount interestRate:interestRate timeInterval:time]*interestRate;
}





/*
 this function will give you the amount of equal payments
 needed to amount to a future value with a given period time  and interest rate
 
 */
-(double)getUniformCashFlowAmount_futureVal:(double)futureValue interestRate:(double)interestRate timeInterval:(double)timeInterval
{
    return futureValue*[self getUniformCashFlowAmountFutureGiven_interestRate:interestRate timeInterval:timeInterval];//getUniformCashFlowFutureValue_AmountGiven:interestRate :timeInterval];
}


/*
 this funciton gives the amount of equal payments 
 that will be equivalent to the  present worth amount 
 */
-(double)getUniformCashFlowAmount_presentVal:(double)presentValue interestRate:(double)interestRate timeInterval:(double)timeInterval
{
    return presentValue*[self getUniformCashFlowAmountPresentGiven_interestRate:interestRate timeInterval:timeInterval];
}


/*
 this function will give you the future value given that you put equal payments for a period of time at
 
 */
-(double)getUniformCashFlowFutureValue_amount:(double)amount interestRate:(double)interestRate timeInterval:(double)timeInterval
{
    return amount*[self getUniformCashFlowFutureValueAmountGiven_interestRate:interestRate timeInterval:timeInterval];
}

/*
 this function will give you the amount of equal payments
 needed to emulate to a present worth with a given period time  and interest rate
 ex: it could be used to calculate loans
 */

-(double)getUniformCashFlowPresentWorth_amount:(double)amount interestRate:(double)interestRate timeInterval:(double)timeInterval
{
    NSLog(@"amount:%f * (p/a):%f | n:%f",amount,[self getUniformCashFlowPresentWorthAmountGiven_interestRate:interestRate timeInterval:timeInterval],timeInterval);
    return amount*[self getUniformCashFlowPresentWorthAmountGiven_interestRate:interestRate timeInterval:timeInterval];
}

/*
 this function will give you the future value of a given present worth after a given period of time
 
 */

-(double)getSingleFormCashFlowPresentWorth_futureValue:(double)futureValue interestRate:(double)interestRate timeInterval:(double)timeInterval;
{
    return futureValue*[self getSingleFormCashFlowPresentWorthFutureGiven_interestRate:interestRate timeInterval:timeInterval];
}

/*
 this function will give you the future value of a given present worth after a given period of time
 
 */
-(double)getSingleFormCashFlowFuture_presentValue:(double)presentValue interestRate:(double)interestRate timeInterval:(double)timeInterval
{
    return presentValue*[self getSingleFormCashFlowPFuturePresentGiven_interestRate:interestRate timeInterval:timeInterval];
}



#pragma  mark private implementations
////
-(double)getUniformCashFlowAmountFutureGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval//a/f
{
    return (1.00/[self getUniformCashFlowFutureValueAmountGiven_interestRate:interestRate timeInterval:timeInterval]);
}
-(double)getUniformCashFlowFutureValueAmountGiven_interestRate :(double)interestRate timeInterval:(double)timeInterval//f/a
{
    double numerator= pow(( 1+interestRate),timeInterval)-1;
    double denominator= interestRate;
    return numerator/denominator;
}
-(double)getUniformCashFlowPresentWorthAmountGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval//p/a
{
    
   
    double numerator= pow(( 1+interestRate),timeInterval)-1;
    double denominator= interestRate* pow((1+interestRate),timeInterval);
    double result=numerator/denominator;
       return result;

}
-(double)getUniformCashFlowAmountPresentGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval//a/p
{
    return (1.00/[self getUniformCashFlowPresentWorthAmountGiven_interestRate:interestRate timeInterval:timeInterval]);
}



-(double)getSingleFormCashFlowPresentWorthFutureGiven_interestRate :(double)interestRate timeInterval:(double)timeInterval;//(p/f
{
    return 1/[self getSingleFormCashFlowPFuturePresentGiven_interestRate:interestRate timeInterval:timeInterval];
}
-(double)getSingleFormCashFlowPFuturePresentGiven_interestRate:(double)interestRate timeInterval:(double)timeInterval//f/p
{
     return pow((1+interestRate),timeInterval);
}

///







@end
