//
//  LoanDisplayViewController.m
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "LoanDisplayViewController.h"
#import "LoanProfileData.h"
#import "UniformCashFlowView.h"

@interface LoanDisplayViewController ()
-(void)updateGraph;
@end

@implementation LoanDisplayViewController


@synthesize totalPaymentPeriod;
@synthesize loanProfileName;
@synthesize interestSlider;
@synthesize borrowedAmount;
@synthesize yearlyInterest;
@synthesize lp;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.yearlyInterest.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100 ];
    [[LoanProfileData getInstance] setBoundsOnInterest:self.interestSlider];
    


}

-(void) feedTheComponents
{
    self.totalPaymentPeriod.text=[NSString stringWithFormat:@"%i",self.lp.paybackTime] ;
    self.loanProfileName.text=lp.name;
    self.interestSlider.value=lp.interestRate;
    self.borrowedAmount.text=[NSString stringWithFormat:@"%.02f",self.lp.loanAmount];
    self.yearlyInterest.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value *100];
    
    
   
     LoanProfileData* lpd= [LoanProfileData getInstance];
    
    if (self.lp.lPId==0)
    {
        
        
        [self.lp setCompounding:lpd.currentProdile.compounding];
        [self.lp setPaymentFrequency:lpd.currentProdile.paymentFrequency];
        [self.lp setPaybackTime:lpd.currentProdile.paybackTime];
    }
      
    [lpd setCurrentProdile:self.lp];
          [self updateGraph];
    

    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
   // LoanProfileData* lpd=[LoanProfileData getInstance];
    
    
    if (!(self.lp==nil))
    {
        [self feedTheComponents];
        
    }
    else
    {
        self.lp=[[LoanProfile alloc]init];
        LoanProfileData* lpd= [LoanProfileData getInstance];
        
        [lpd setCurrentProdile:self.lp];
        

       // [self updateGraph];
    }
  
 
//    if (lpd.currentProdile!=nil)
//    {
//        self.lp=lpd.currentProdile;
//    
//        [self feedTheComponents];
//    }
    
    
   
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewDidUnload {
  
    [self setLoanProfileName:nil];
    [self setBorrowedAmount:nil];
    [self setTotalPaymentPeriod:nil];
    [super viewDidUnload];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    return  [super tableView:tableView cellForRowAtIndexPath:indexPath];
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
          self.lp.loanAmount=[self.borrowedAmount.text doubleValue];
    self.lp.name=self.loanProfileName.text;
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}



#pragma mark - custom functions

-(void)changeTimeLabel
{
    
    if ([self.lp everythingIsFilled])
    {
        [self.lp setPaybackTime:[self.lp calculatePayBackTime]];
        self.totalPaymentPeriod.text= [NSString stringWithFormat:@"%i",self.lp.paybackTime] ;
        
    }
    [self updateGraph];
}


- (IBAction)sliderValueChanged:(id)sender
{
    
    self.yearlyInterest.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100 ];
    LoanProfileData* lpd=[LoanProfileData getInstance];
    
    [lpd.currentProdile setInterestRate:self.interestSlider.value];

    [self changeTimeLabel];
    
}


-(IBAction)addPressed:(id)sender// function used to add or update
{
    LoanProfileData* lpd=[LoanProfileData getInstance];
    
    LoanProfile *lprofile=[[LoanProfile alloc]initCreateLoanProfile_name:self.loanProfileName.text loanAmount:[self.borrowedAmount.text floatValue]payBackTime:[self.totalPaymentPeriod.text intValue] equalPaymentAmount:self.lp.equalPaymentAmount yearlyIntRate: self.interestSlider.value];
    if ((self.lp.lPId>0)&&(self.lp!=nil))
    {
        int lpid=self.lp.lPId;
        
        [lprofile setCompounding:self.lp.compounding];
        [lprofile setEqualPaymentAmount:self.lp.equalPaymentAmount];
        [lprofile setPaymentFrequency:self.lp.paymentFrequency];
        [lprofile setInterestRate:self.lp.interestRate];
        self.lp=lprofile;
        self.lp.lPId=lpid;
        [lpd updateLoanProfile_lp:self.lp];
        
    }
    else
    {
        
        
        [lpd insertLoanProfile_lp:lprofile];
        NSLog(@"total Loan Profiles recorded in device:%i",[[lpd findAllprofiles] count]);
    }
}

-(void)updateGraph
{
    
    
    if ([self.lp everythingIsFilled])
    {
        [[self.bottomScrollView.subviews objectAtIndex:0] setMainProfile_profileType:@"loan" profile:self.lp];
        [[self.bottomScrollView.subviews objectAtIndex:0] setNeedsDisplay];
        
        
        
        UniformCashFlowView* thegraph= [self.bottomScrollView.subviews objectAtIndex:0];
        UIScrollView* scroll=self.bottomScrollView;
       
        double xmargin=scroll.frame.size.width/50;
        
        NSLog(@"graph frame b4:(%f,%f,%f,%f)",thegraph.frame.origin.x,thegraph.frame.origin.y,thegraph.frame.size.width,thegraph.frame.size.height);
        NSLog(@"added by:%f",(self.lp.paybackTime*(xmargin*2)));
        
        if ([thegraph needsToStrech] )
        {
            [thegraph setFrame:CGRectMake(0, 0, scroll.frame.size.width+(self.lp.paybackTime*(xmargin*2)), 129)];
            
        }
        
        [self.bottomScrollView setContentSize:thegraph.frame.size];
        
        NSLog(@"graph frame after:(%f,%f,%f,%f)",thegraph.frame.origin.x,thegraph.frame.origin.y,thegraph.frame.size.width,thegraph.frame.size.height);
    }
  

    
}


-(BOOL)validateTextFieldDecimalVal:(NSString*)amountInput
{
    NSError *error = NULL;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[a-z]\\w"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSUInteger numberOfMatches = [regex numberOfMatchesInString:amountInput
                                                        options:0
                                                          range:NSMakeRange(0, [amountInput length])];
    
    return numberOfMatches==0;
}


#pragma -mark UITextfield functions

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.loanProfileName.text length]>0)
    {
        [self.lp setName:self.loanProfileName.text];
        [self changeTimeLabel];
    }
    
    
    if ([self.borrowedAmount.text length]>0)
    {
        
        if ([self validateTextFieldDecimalVal:self.borrowedAmount.text])
        {
            [self.lp setLoanAmount:[self.borrowedAmount.text doubleValue]];
            [self changeTimeLabel];
        }
        else
        {
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"validation problem" message:@"validation problem: You Probably Put A Non Decimal Digit In Loan Amount Area " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
            
        }

       
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
       [self.loanProfileName resignFirstResponder];
   
//    [self.totalPaymentPeriod resignFirstResponder];
    [self.borrowedAmount resignFirstResponder];
    return YES;
}



@end
