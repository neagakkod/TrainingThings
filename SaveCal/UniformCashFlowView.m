//
//  UniformCashFlowView.m
//  SaveCal
//
//  Created by user on 10/20/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "UniformCashFlowView.h"
#import "CashFlowAnalyzer.h"


@interface UniformCashFlowView (private)
-(void)putLabels_timeIntervals:(int)timeIntervals;
-(double)scaleToGraph_highestValue:(double) hightestValue currentValue:(double)currentValue;
@end
@implementation UniformCashFlowView
@synthesize currentimes;
@synthesize timeAxis;
@synthesize moneyAxis;
@synthesize middleAxis;
@synthesize xMargin;
@synthesize yMargin;
@synthesize lengthOfTimeAxis;
@synthesize lengthOfMoneyAxis;
@synthesize lprofile;
@synthesize sprofile;
@synthesize loan;
@synthesize toomuch;
static double initialXMargin=0;
static double initialYMargin=0;
static int drawingCount=0;

#pragma  mark static methods
+(int)getDrawingNumber

{
    return drawingCount;
}

+(double)getInitialXMargin
{
    return initialXMargin;
}

+(double)getInitialYMargin
{
    return initialYMargin;
}


#pragma mark dynamic methods
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
//
//    + (Class)layerClass
//    {
//        return [CATiledLayer class];
//    }


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    drawingCount++;
    
  
   // [self removeLabels];
    [self drawEmptyGraph];
     if (self.loan==1)
    {
        if (self.lprofile==nil)
        {
             [self generateGraph_lendingAmount:0 interestRate:0 equalPaymentAmount:0 timeIntervals: 0];
        }
        else
            [self generateGraph_lendingAmount:self.lprofile.loanAmount interestRate:[self.lprofile calculateEffectiveInterestRate] equalPaymentAmount:self.lprofile.equalPaymentAmount timeIntervals: self.lprofile.paybackTime];
    }
    else
    {
        if (self.sprofile==nil)
        {
            [self generateGraph_initialDeposit:0 interestRate:0 timeIntervals:0 goal:0 equalDepositAmount:0];
        }
        else
            [self generateGraph_initialDeposit:self.sprofile.startingWith interestRate:[self.sprofile calculateEffectiveInterestRate]  timeIntervals:self.sprofile.savingsTime goal:self.sprofile.goal equalDepositAmount:self.sprofile.equalDepositAmount];
    }
    
    
   
}



-(void)setMainProfile_profileType:(NSString *) profileType profile:(id)profile
{
    if([profileType isEqualToString:@"save"])
    {
        [self setSprofile:profile];
        [self setLprofile:nil];
        self.loan=0;
    }
    
    else
    {
        [self setLprofile:profile];
        [self setSprofile:nil];
        self.loan=1;
    }
}
-(BOOL)needsToStrech
{
    if (self.sprofile!=nil)
    {
        if (sprofile.savingsTime>21)
        {
            return YES;
          
        }
        else
            return NO;
    }
    else if (self.lprofile!=nil)
    {
        if (lprofile.paybackTime>21)
        {
            return YES;
        }
        else
            return NO;

    }
    else
       return NO;

}
-(void)drawEmptyGraph
{
    
    self.xMargin=self.frame.size.width/50;
    self.yMargin=self.frame.size.height/50;
    
    
    if (drawingCount==1)
    {
        initialYMargin=self.yMargin;
        initialXMargin=self.xMargin;
    }
    self.yMargin=initialYMargin;
    self.xMargin=initialXMargin;
    
    
    self.lengthOfMoneyAxis=self.frame.size.height-yMargin;
    
  //  [self calculateNewTimeAxis];
    self.lengthOfTimeAxis=self.frame.size.width-(2*xMargin);
    self.middleAxis= lengthOfMoneyAxis*3/4;
    
    self.timeAxis= [UIBezierPath bezierPath];
    [self.timeAxis moveToPoint:CGPointMake(xMargin, middleAxis)];
    [self.timeAxis addLineToPoint:CGPointMake(lengthOfTimeAxis, middleAxis)];
    [self.timeAxis closePath];
    [[UIColor redColor] setStroke];
    self.timeAxis.lineWidth= 1;
    [self.timeAxis stroke];
    
    
    self.moneyAxis=[UIBezierPath bezierPath];
    [self.moneyAxis moveToPoint:CGPointMake(xMargin, yMargin)];
    [self.moneyAxis addLineToPoint:CGPointMake(xMargin,lengthOfMoneyAxis)];
    [self.moneyAxis closePath];
    [[UIColor greenColor]setStroke];
    self.moneyAxis.lineWidth=1;
    [self.moneyAxis stroke];
    [self.moneyAxis removeAllPoints];
    
}
-(double)scaleToGraph_highestValue:(double)hightestValue currentValue:(double)currentValue
{
    
    double graphTallestHeight=(3*lengthOfMoneyAxis)/4-initialYMargin;
    double x;
    x=(graphTallestHeight*currentValue)/hightestValue;
    return  x;

}


-(void)generateGraph_lendingAmount:(double)lendingAmount interestRate:(double)interestRate equalPaymentAmount:(double)equalPaymentAmount timeIntervals:(int)timeIntervals
{
    double intervalLength=0;
   // int timeIntervals=0;
       
    CashFlowAnalyzer* cfa= [CashFlowAnalyzer getInstance];
    if (lendingAmount>0)
    {
        // timeIntervals=[cfa getTimeIntervalsNeeded_presentWorth:lendingAmount interestRate:interestRate amount:equalPaymentAmount];
        intervalLength=self.lengthOfTimeAxis/(1+timeIntervals);
        [self putLabels_timeIntervals:timeIntervals];

    }
     
    
    
    UIBezierPath*  d,*r;//,*limit;
   
   
    for (int i=0;i<=timeIntervals ; i++)
    {
      
       //interest rate/12
        float ley=self.middleAxis- [self scaleToGraph_highestValue:lendingAmount currentValue:lendingAmount-[cfa getUniformCashFlowPresentWorth_amount:equalPaymentAmount interestRate:interestRate timeInterval:i]];
        float lex=intervalLength*i+xMargin;
        
      //  NSLog(@"%f",ley);
        
        
        d=  [UIBezierPath bezierPath];
        r= [UIBezierPath bezierPath];
        
//        [ r  moveToPoint:CGPointMake(lex, self.middleAxis)] ;
//        [r addLineToPoint:CGPointMake(intervalLength*i+xMargin, ley-5)];
//        [[UIColor yellowColor] setStroke];
//        r.lineWidth = 3; // Or whatever width you want
//        [r stroke];
//        
        
        
        [ d  moveToPoint:CGPointMake(lex, self.middleAxis)] ;
        [d addLineToPoint:CGPointMake(lex,ley )];
        [[UIColor redColor] setStroke];
        d.lineWidth = 6; // Or whatever width you want
        [d stroke];
        
       
        
    }
//    limit= [UIBezierPath bezierPath];
//    
//    [ limit  moveToPoint:CGPointMake(x, lim)] ;
//    [limit addLineToPoint:CGPointMake(x*3,lim)];
//    [[UIColor yellowColor] setStroke];
//    CGFloat dashPatern[2] = {1.0, 1.0};
//    [limit setLineDash:dashPatern count:2 phase:0.0];
//    limit.lineWidth = 1; // Or whatever width you want
//    [limit stroke];

    
    
    
    
}

-(void)generateGraph_lendingAmount:(double)lendingAmount interestRate:(double)interestRate timeIntervals:(int)timeIntervals
{
   
    
}

-(void)generateGraph_initialDeposit:(double)initialDeposit interestRate:(double)interestRate timeIntervals:(int)timeIntervals goal:(double)goal equalDepositAmount:(double)equalDepositAmount
{
    double intervalLength=0;

    [self putLabels_timeIntervals:timeIntervals];

    CashFlowAnalyzer* cfa= [CashFlowAnalyzer getInstance];
    
    if (goal>0 & equalDepositAmount>0)
    {
        //timeIntervals= [cfa getTimeIntervalsNeeded_futureWorth:(goal-initialDeposit) interestRate:interestRate amount:equalDepositAmount];
    
    
        
            
          
        intervalLength= self.lengthOfTimeAxis/timeIntervals;
           [self putLabels_timeIntervals:timeIntervals];
      //
        self.currentimes=timeIntervals;
      
        
        UIBezierPath*  d,*r;//,*limit;
        
        
        for (int i=0;i<=timeIntervals ; i++)
        {
            
          
            float ley=self.middleAxis- [self scaleToGraph_highestValue:goal currentValue:[cfa getUniformCashFlowFutureValue_amount:equalDepositAmount interestRate:interestRate timeInterval:i]];
            float lex=intervalLength*i;//+xMargin;
            
           // NSLog(@"%f",ley);
            //NSLog(@"ley is :goal-%f",[cfa getUniformCashFlowFutureValue_amount:equalDepositAmount interestRate:interestRate timeInterval:i]);
            
            d=  [UIBezierPath bezierPath];
            r= [UIBezierPath bezierPath];
            
            //        [ r  moveToPoint:CGPointMake(lex, self.middleAxis)] ;
            //        [r addLineToPoint:CGPointMake(intervalLength*i+xMargin, ley-5)];
            //        [[UIColor yellowColor] setStroke];
            //        r.lineWidth = 3; // Or whatever width you want
            //        [r stroke];
            //
            
            
            [ d  moveToPoint:CGPointMake(lex, self.middleAxis)] ;
            [d addLineToPoint:CGPointMake(lex,ley )];
            [[UIColor redColor] setStroke];
            d.lineWidth = 6; // Or whatever width you want
            [d stroke];
            
            
            
        }

    }

}
-(void)putLabels_timeIntervals:(int)timeIntervals
{
    self.currentimes=timeIntervals;
    double intervalLength= self.lengthOfTimeAxis/(timeIntervals+1);
    UILabel* number;
    if ([self.subviews count] >0)
    {
        UILabel* currentLabel;
        for (int i=0; i<[self.subviews count]; i++)
        {
            if ([[self.subviews objectAtIndex:i] isKindOfClass:[UILabel class]] )
            {
                currentLabel=[self.subviews objectAtIndex:i];
                currentLabel.text=@"";
               // [currentLabel removeFromSuperview];
            }
        }
    }
    
    for (int i=0; i<=timeIntervals; i++)
    {
        number= [[UILabel alloc] initWithFrame:CGRectMake(intervalLength*i+xMargin, self.middleAxis+3, 10, 10)];
        number.numberOfLines=2;
        number.text=[NSString stringWithFormat:@"%i",i ];
        if ([number.text length]>2)
        {
         //  number.text= [self breakIt:number.text];
           // NSLog(@"%@",number.text);
            [number setFrame:CGRectMake(intervalLength*i+xMargin, self.middleAxis-10, 10, 40)];
        }
        
        number.font= [UIFont systemFontOfSize:8];
        number.backgroundColor=[UIColor clearColor];
        number.textColor=[UIColor blueColor ];
    
        [self addSubview:number];
        
    }
[self setNeedsLayout];
}
-(NSString*)breakIt:(NSString*)thedigits
{
   return  [ NSString stringWithFormat:@"%@\n%@",[thedigits substringToIndex:1],[thedigits substringFromIndex:2] ];
}




@end
