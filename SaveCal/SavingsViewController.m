//
//  SavingsViewController.m
//  SaveCal
//
//  Created by user on 10/23/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "SavingsViewController.h"
#import "UniformCashFlowView.h"
#import "SavingsProfileData.h"

@interface SavingsViewController ()
-(void)updateGraph;
@end

@implementation SavingsViewController


@synthesize totalSavingsPeriod;
@synthesize initialDeposit;
@synthesize goalAmount;
@synthesize bottomScrollView;
@synthesize yearlyInterest;//label
@synthesize savingsProfileName;
@synthesize sp;
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
   // UniformCashFlowView* thegraph=[[UniformCashFlowView alloc]init];
   // NSLog(@"graph allocinited:(%f,%f,%f,%f)",thegraph.frame.origin.x,thegraph.frame.origin.y,thegraph.frame.size.width,thegraph.frame.size.height);

    double interestForDisplay=self.interestSlider.value*100;
    self.yearlyInterest.text=[NSString stringWithFormat:@"%.02f%%",interestForDisplay ];
    //(CGRect){.origin=CGPointMake(0.0f, 0.0f), .size=image.size};
    
    CGRect aframe=self.bottomScrollView.frame;
    [self.bottomScrollView setFrame:aframe];
    NSLog(@"scroll frame:(%f,%f,%f,%f)",aframe.origin.x,aframe.origin.y,aframe.size.width,aframe.size.height);
    
}
-(void)feedTheComponents
{
    self.totalSavingsPeriod.text=[NSString stringWithFormat:@"%i",self.sp.savingsTime];
    self.goalAmount.text=[NSString stringWithFormat:@"%.02f",self.sp.goal ];
    self.interestSlider.value=self.sp.interestRate;
    self.yearlyInterest.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value *100];
    self.savingsProfileName.text=self.sp.name;
    self.initialDeposit.text=[NSString stringWithFormat:@"%.02f",self.sp.startingWith ];
    
    SavingsProfileData*spd=[SavingsProfileData getInstance];
   
    if (self.sp.sPId==0)
    {
        [self.sp setCompounding:spd.currentProfile.compounding];
        [self.sp setDepositFrequency:spd.currentProfile.depositFrequency];
        [self.sp setSavingsTime:spd.currentProfile.savingsTime];
        
    }
    [spd setCurrentProfile:self.sp];
    [self updateGraph];
    
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
//    SavingsProfileData* svpd=[SavingsProfileData getInstance];
  
//    if (svpd.currentProfile!=nil)
//    {
//         self.sp=svpd.currentProfile;
//    }
      [[SavingsProfileData getInstance] setBoundsOnInterest:self.interestSlider];

    if (self.sp!=nil)
    {
        [self feedTheComponents];
    }
    else
    {
        self.sp=[[SavingsProfile alloc]init];
        SavingsProfileData* svpd=[SavingsProfileData getInstance];
        [svpd setCurrentProfile:self.sp];
        
    }
    
   
    //[self updateGraph];
       
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
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
//    
    // Configure the cell...
    
//    return cell;
    
    // Recalculate indexPath based on hidden cells
   // indexPath = [self offsetIndexPath:indexPath];
    
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
   // NSLog(@"doing it");
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    self.sp.goal=[self.goalAmount.text doubleValue];
    self.sp.startingWith=[self.initialDeposit.text doubleValue];
    self.sp.name=self.savingsProfileName.text ;
    
}
#pragma mark UITexfieldDelegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{

    if ([self.savingsProfileName.text length]>0)
    {
        [self.sp setName:self.savingsProfileName.text];
        
    }
    
    if ([self.goalAmount.text length]>0)
    {
        if ([self validateTextFieldDecimalVal:self.goalAmount.text])
        {
            [self.sp setGoal:[self.goalAmount.text doubleValue]];
            [self changeTimeLabel];
        }
        else
        {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"validation problem" message:@"validation problem: You Probably Put A Non Decimal Digit In Goal Amount Area " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
    }
       
    if ([self.initialDeposit.text length]>0)
    {
        
        if ([self validateTextFieldDecimalVal:self.initialDeposit.text ])
        {
            
            [self.sp setStartingWith:[self.initialDeposit.text doubleValue]];
            [self changeTimeLabel];
        }
        else
        {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"validation problem" message:@"validation problem: You Probably Put A Non Decimal Digit In initial deposit Area " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
    }

     
    [self.savingsProfileName resignFirstResponder];
    [self.goalAmount resignFirstResponder];
    [self.initialDeposit resignFirstResponder];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self.goalAmount.text length]>0)
    {
        if ([self validateTextFieldDecimalVal:self.goalAmount.text])
        {
            [self.sp setGoal:[self.goalAmount.text doubleValue]];
            [self changeTimeLabel];
        }
        else
        {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"validation problem" message:@"validation problem: You Probably Put A Non Decimal Digit In Goal Amount Area " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
    }
    
    if ([self.initialDeposit.text length]>0)
    {
        
        if ([self validateTextFieldDecimalVal:self.initialDeposit.text ])
        {
            
            [self.sp setStartingWith:[self.initialDeposit.text doubleValue]];
            [self changeTimeLabel];
        }
        else
        {
            
            UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"validation problem" message:@"validation problem: You Probably Put A Non Decimal Digit In initial deposit Area " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
            [alert show];
        }
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

#pragma mark custom methods
-(void)changeTimeLabel
{
    
    if ([self.sp everythingIsFilled])
    {
        [self.sp setSavingsTime:[self.sp calculateSavingsTimeWithEffIntRate]];
        self.totalSavingsPeriod.text=[NSString stringWithFormat:@"%i",self.sp.savingsTime];   
    }
    [self updateGraph];
}




-(void)updateGraph
{
    [[self.bottomScrollView.subviews objectAtIndex:0] setMainProfile_profileType:@"save" profile:self.sp];
  
    
    

      [[self.bottomScrollView.subviews objectAtIndex:0] setNeedsDisplay];
    UniformCashFlowView* thegraph= [self.bottomScrollView.subviews objectAtIndex:0];
     NSLog(@"graph frame b4:(%f,%f,%f,%f)",thegraph.frame.origin.x,thegraph.frame.origin.y,thegraph.frame.size.width,thegraph.frame.size.height);
    if ([thegraph needsToStrech] )
    {
        [thegraph setFrame:CGRectMake(0, 0, 600, 129)];

    }
   
       [self.bottomScrollView setContentSize:thegraph.frame.size];
    NSLog(@"graph frame after:(%f,%f,%f,%f)",thegraph.frame.origin.x,thegraph.frame.origin.y,thegraph.frame.size.width,thegraph.frame.size.height);
    // thegraph

}

-(IBAction)addOrSavePressed:(id)sender
{
    
    SavingsProfileData* spd=[SavingsProfileData getInstance];
    
    SavingsProfile *sProfile=[[SavingsProfile alloc] initCreateSavingsProfile_name:self.savingsProfileName.text startingWith:[self.initialDeposit.text doubleValue]  savingsTime:[self.totalSavingsPeriod.text intValue] equalDepositAmount:self.sp.equalDepositAmount yearlyIntRate:self.interestSlider.value goal:[self.goalAmount.text doubleValue]];
    
    if ((self.sp!=nil)&&(self.sp.sPId!=0))
    {
        int spid=self.sp.sPId;
        [sProfile setCompounding:self.sp.compounding];
        [sProfile setEqualDepositAmount:self.sp.equalDepositAmount];
        [sProfile setDepositFrequency:self.sp.depositFrequency];
        [sProfile setInterestRate:self.sp.interestRate];
        self.sp=sProfile;
        self.sp.sPId=spid;
        [spd updateSavingsProfile_sp:self.sp]; //updateLoanProfile_sp:self.lp];
        
    }
    else
    {
        
        [spd insertSavingsProfile_sp:sProfile];
      //  [lpd insertLoanProfile_lp:lprofile];
        NSLog(@"Total Savings Profiles recorded in device:%i",[[spd findAllprofiles] count]);
    }
}
-(void)sliderValueChanged:(id)sender
{
    
      self.yearlyInterest.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100 ];
     SavingsProfileData* spd=[SavingsProfileData getInstance];
    [[spd currentProfile] setInterestRate:self.interestSlider.value];
   
     [self changeTimeLabel];
    
}

@end
