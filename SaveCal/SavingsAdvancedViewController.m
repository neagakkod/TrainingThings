//
//  SavingsAdvancedViewController.m
//  SaveCal
//
//  Created by user on 10/23/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "SavingsAdvancedViewController.h"
#import "SavingsProfileData.h"

@interface SavingsAdvancedViewController ()

@end

@implementation SavingsAdvancedViewController
@synthesize sp;
@synthesize totalDepositsNeeded;
@synthesize  eqDepositAmount;
@synthesize interestSlider;
@synthesize interestLabel;
@synthesize  interestCompounding;
@synthesize depositFrequency;


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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    SavingsProfileData* spd=[SavingsProfileData getInstance];
    SavingsProfile* cSP= [[SavingsProfile alloc]init];//svpd.currentProfile;
    if (spd.currentProfile!=nil)
    {
        cSP=spd.currentProfile;
    }
    else
        spd.currentProfile=cSP;
    [[SavingsProfileData getInstance] setBoundsOnInterest:self.interestSlider];

    
    self.eqDepositAmount.text=[NSString stringWithFormat:@"%.02f",cSP.equalDepositAmount];
    [self.interestSlider setValue:cSP.interestRate];
    self.interestLabel.text= [NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100];
    [self.interestCompounding setSelectedSegmentIndex:[self convertForIndex:cSP.compounding]];
    [self.depositFrequency setSelectedSegmentIndex:[self convertForIndex: cSP.depositFrequency]];
    
    self.sp=spd.currentProfile;
    
    [self changeTimeLabel];
    
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
     return [super tableView:tableView numberOfRowsInSection:section];}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
#pragma  mark textfield delegate methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    
   
    [self.eqDepositAmount resignFirstResponder];
    
    
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([self validateTextFieldDecimalVal:self.eqDepositAmount.text])
    {
        
        [self.sp setEqualDepositAmount:[self.eqDepositAmount.text doubleValue]];
        
        [self changeTimeLabel];
    }
    
    else
    {
        UIAlertView* alert=[[UIAlertView alloc] initWithTitle:@"validation problem" message:@"hmmm. You probably put a non decimal digit in the deposit amount area. " delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
}

#pragma  mark custom methods
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
-(void)changeTimeLabel
{
    
    if ([self.sp everythingIsFilled])
    {
        [self.sp setSavingsTime:[self.sp calculateSavingsTimeWithEffIntRate]];
        self.totalDepositsNeeded.text=[NSString stringWithFormat:@"%i",self.sp.savingsTime];
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


-(IBAction)interestChangded :(id)sender
{
    self.interestLabel.text=[NSString stringWithFormat:@"%.02f%%",self.interestSlider.value*100 ];
    [self.sp setInterestRate:self.interestSlider.value];
    
    //changing the time unit value
    
    [self changeTimeLabel];

    
//    SavingsProfileData* svpd=[SavingsProfileData getInstance];
//    SavingsProfile* cSP= svpd.currentProfile;
//    
//    [cSP setInterestRate:self.interestSlider.value];
}
-(IBAction)depositChanged :(id)sender
{
    [self.sp setEqualDepositAmount:[self.eqDepositAmount.text doubleValue]];
    [self changeTimeLabel];
//    SavingsProfileData* svpd=[SavingsProfileData getInstance];
//    SavingsProfile* cSP= svpd.currentProfile;
//    
//    [cSP setEqualDepositAmount:[self.eqDepositAmount.text doubleValue]];
}
-(IBAction)compoundingChanged:(id)sender
{
//    SavingsProfileData* svpd=[SavingsProfileData getInstance];
//    SavingsProfile* cSP= svpd.currentProfile;
//    
//    [cSP setCompounding:self.interestCompounding.selectedSegmentIndex ];
    
    [self.sp setCompounding:[self convertForFrequency:self.interestCompounding.selectedSegmentIndex] ];
    [self changeTimeLabel];
    
}
-(IBAction)frequencyChanged:(id)sender
{
//    SavingsProfileData* svpd=[SavingsProfileData getInstance];
//    SavingsProfile* cSP= svpd.currentProfile;
//    
//    [cSP setDepositFrequency:self.depositFrequency.selectedSegmentIndex];

    [self.sp setDepositFrequency:[self convertForFrequency:self.depositFrequency.selectedSegmentIndex] ];
    
    [self changeTimeLabel];
}
- (void)viewDidUnload {
    [self setTotalDepositsNeeded:nil];
    [super viewDidUnload];
}
@end
