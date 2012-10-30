//
//  LoanAdvancedViewController.m
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "LoanAdvancedViewController.h"
#import "LoanProfileData.h"

@interface LoanAdvancedViewController ()

@end

@implementation LoanAdvancedViewController
@synthesize lp;
@synthesize timeUnitLabels;
@synthesize paymentFrequency;
@synthesize eqPaymentAmount;
@synthesize interestCompounding;
@synthesize interestLabel;
@synthesize interestSlider;

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
    LoanProfileData* lpd=[LoanProfileData getInstance];

    LoanProfile* cLP= [[LoanProfile alloc] init];
    
    if (lpd.currentProdile!=nil)
    {
     cLP= lpd.currentProdile;
    }
     else
         lpd.currentProdile=cLP;

    
     
     
    
//    double maxIntValue=[[[NSUserDefaults standardUserDefaults] stringForKey:@"maxItrVal"] doubleValue];
//    double minIntValue=[[[NSUserDefaults standardUserDefaults] stringForKey:@"minItrVal"] doubleValue];
//    
//     NSLog(@"maxitrval:%f",maxIntValue);
//     NSLog(@"maxitrval:%f",minIntValue);
//    
//    if (maxIntValue>0&&minIntValue>0)
//    {
//      if (minIntValue<maxIntValue)
//        {
//            [self.interestSlider setMinimumValue:(minIntValue/100)];
//            [self.interestSlider setMaximumValue:(maxIntValue/100)];
//            
//        }
//    }
//    
//    
    
     
    
    self.eqPaymentAmount.text=[NSString stringWithFormat:@"%.02f",cLP.equalPaymentAmount ];
    [self.interestSlider setValue:cLP.interestRate];
    self.interestLabel.text= [NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100];
    [self.interestCompounding setSelectedSegmentIndex:[self convertForIndex:cLP.compounding ]];
    [self.paymentFrequency setSelectedSegmentIndex:[self convertForIndex:cLP.paymentFrequency]];
    lp=lpd.currentProdile;
    [lpd setBoundsOnInterest:self.interestSlider];

    
    [self changeTimeLabel];

  }

-(void)changeTimeLabel
{
    
    if ([self.lp everythingIsFilled])
    {
        [self.lp setPaybackTime:[self.lp calculatePayBackTime]];
        self.timeUnitLabels.text= [NSString stringWithFormat:@"%i",self.lp.paybackTime] ;
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
   /* static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    */
    // Configure the cell...
    
    return [super tableView:tableView cellForRowAtIndexPath:indexPath];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
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
*/

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
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.lp setEqualPaymentAmount:[self.eqPaymentAmount.text doubleValue]];
    
    [self changeTimeLabel];
    [self.eqPaymentAmount resignFirstResponder];
    
    
    return  YES;
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
#pragma mark custom methods

-(IBAction)interestChangded :(id)sender
{
  
   
    self.interestLabel.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100 ];
    [self.lp setInterestRate:self.interestSlider.value];
    
    //changing the time unit value

    [self changeTimeLabel];
}


-(IBAction)compoundingChanged:(id)sender
{
    [self.lp setCompounding:[self convertForFrequency:self.interestCompounding.selectedSegmentIndex] ];
    [self changeTimeLabel];
    
}

-(IBAction)frequencyChanged:(id)sender
{
    [self.lp setPaymentFrequency:[self convertForFrequency:self.paymentFrequency.selectedSegmentIndex] ];
    
    [self changeTimeLabel];
}
-(int)convertForFrequency:(int)index
{
    if (index==0) {
        return 1;
    }
    else if (index==1)
    {
        return 2;
    }
    else if(index==2)
    {
        return 4;
    }
    else 
    {
        return 12;
    }
}
-(int)convertForIndex:(int)index
{
    if (index==1)
    {
        return 0;
    }
    else if (index==2)
    {
        return 1;
    }
    else if(index==4)
    {
        return 2;
    }
    else
    {
        return 3;
    }

}
- (void)viewDidUnload {
    [self setTimeUnitLabels:nil];
    [super viewDidUnload];
}
@end
