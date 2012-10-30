//
//  CustomerViewController.m
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "CustomerViewController.h"
#import "AddressData.h"
#import "LoanProfileData.h"
#import "SavingsProfileData.h"
#import "CustomerData.h"

@interface CustomerViewController ()

@end

@implementation CustomerViewController

@synthesize aac;
@synthesize loaner;
@synthesize firstName;
@synthesize lastName;
@synthesize streetAddress;
@synthesize city;
@synthesize region;
@synthesize zipCode;
@synthesize phone;
@synthesize theCustomer;
@synthesize theAddress;

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
    [self feedTheUIOutlets];

    // Uncomment the following li/Users/user/Documents/herman_Practice/SaveCal/SaveCal/en.lproj/MainStoryboard.storyboardne to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
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
#pragma mark - Textfield view delegate

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.lastName resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.streetAddress resignFirstResponder];
    [self.city resignFirstResponder];
    [self.region resignFirstResponder];
    [self.zipCode resignFirstResponder];
    [self.phone resignFirstResponder];
    /*
     @synthesize loanerLabel;
     @synthesize firstName;
     @synthesize lastName;
     @synthesize streetAddress;
     @synthesize city;
     @synthesize region;
     @synthesize zipCode;
     @synthesize phone;
     
     */
    return YES;
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

- (void)viewDidUnload
{
   // [self setLoanerLabel:nil];
    [self setFirstName:nil];
    [self setLastName:nil];
    [self setStreetAddress:nil];
    [self setCity:nil];
    [self setRegion:nil];
    [self setZipCode:nil];
    [self setPhone:nil];
    [super viewDidUnload];
}

#pragma mark custom methods

-(void)feedTheUIOutlets
{
    if (self.theCustomer!=nil)
    {
        
        NSLog(@"current customer: %@",self.theCustomer);
        
        if ([[self.theCustomer objectForKey:@"loaner"] intValue]==1)
        {
             [self.loaner setSelectedSegmentIndex:1];
        }
         else
               [self.loaner setSelectedSegmentIndex:0];
        
        self.firstName.text= [self.theCustomer objectForKey:@"firstName"];
        self.lastName.text= [self.theCustomer objectForKey:@"lastName"];
        self.phone.text=[self.theCustomer objectForKey:@"phone"];
        
        if (self.theAddress==nil)
        {
        
            AddressData* add= [AddressData getInstance];
            NSDictionary* adr=[add findBy_customerid:[[self.theCustomer objectForKey:@"cid"] intValue]];
            self.streetAddress.text= [adr objectForKey:@"streetAddress"];
            self.city.text=[adr objectForKey:@"city"];
            self.region.text=[adr objectForKey:@"region"];
            self.zipCode.text=[adr objectForKey:@"zipcode"];

        }
        else
        {
            self.streetAddress.text= [self.theAddress objectForKey:@"streetAddress"];
            self.city.text=[self.theAddress  objectForKey:@"city"];
            self.region.text=[self.theAddress objectForKey:@"region"];
            self.zipCode.text=[self.theAddress  objectForKey:@"zipcode"];
            
        }

    }
}
- (IBAction)addOrSavePressed:(id)sender
{
    AddressData* add=[AddressData getInstance];
    CustomerData* cd=[CustomerData getInstance];
    NSMutableDictionary* newAddress=[[NSMutableDictionary alloc]init];
    NSMutableDictionary* newCustomer=[[NSMutableDictionary alloc]init];
    [newCustomer setValue:[NSNumber numberWithInteger:self.loaner.selectedSegmentIndex]  forKey:@"loaner"];
    [newCustomer setValue:self.firstName.text forKey:@"firstName"];
    [newCustomer setValue:self.lastName.text forKey:@"lastName"];
    [newCustomer setValue:self.phone.text forKey:@"phone"];
    
  
    
    
    [newAddress setValue:self.streetAddress.text forKey:@"streetAddress"];
    [newAddress setValue:self.city.text forKey:@"city"];
    [newAddress setValue:self.region.text forKey:@"region"];
    [newAddress setValue:self.zipCode.text forKey:@"zipcode"];
    
    
    
    if (self.theCustomer!=nil)
    {
       

        int tempid= [[self.theCustomer objectForKey:@"cid"] intValue] ;
        self.theCustomer=newCustomer;
        
       
    [newAddress setValue:[NSNumber numberWithInt:tempid] forKey:@"customerID"];
        [newCustomer setValue:[NSNumber numberWithInt:tempid] forKey:@"cid"];
          NSLog(@"modified current customer: %@",self.theCustomer);
        [cd updateCustomer_c:newCustomer];
        [add updateAddress_ad:newAddress];
    }
    else
    {
        int customerID=[cd maxcID]+1;
        [newAddress setValue:[NSNumber numberWithInt:customerID] forKey:@"customerID"];
        [cd insertCustomer_c:newCustomer];
        [add insertAddress_ad:newAddress];
    }
}

- (IBAction)loadProfile:(id)sender
{
//    
//    if (<#condition#>) {
//        <#statements#>
//    }
    
   
    NSLog(@"load profile clicked");
   aac = [[UIActionSheet alloc] initWithTitle:@"pic profile" delegate:self cancelButtonTitle:@"ok" destructiveButtonTitle:nil otherButtonTitles:nil];
    
    
    
   UIPickerView*pickerView=[[UIPickerView alloc]initWithFrame:CGRectMake(0.0, 40.0, 320.0, 100.0)];
    pickerView.showsSelectionIndicator = YES;
    
        
    pickerView.dataSource = self;
    pickerView.delegate = self;
    UIToolbar* pickerDateToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    pickerDateToolbar.barStyle = UIBarStyleBlackOpaque;
    [pickerDateToolbar sizeToFit];
    
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    [barItems addObject:flexSpace];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissActionSheet)];
    [barItems addObject:doneBtn];
    
    [pickerDateToolbar setItems:barItems animated:YES];
    
    [aac addSubview:pickerDateToolbar];

    
    
    
    
    
    
    
    [aac addSubview:pickerView];
    [aac showInView:self.tableView];
    [aac setBounds:CGRectMake(0,0,320, 300)];
    
    
    
  
}

-(void)dismissActionSheet
{
    [self.aac dismissWithClickedButtonIndex:0 animated:YES];
}

#pragma mark - PickerView Datasource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.loaner.selectedSegmentIndex==0)
    {
        SavingsProfileData*spd=[SavingsProfileData getInstance];
        return [[spd findAllprofiles] count];
        
    }
    else
    {
        LoanProfileData*lpd=[LoanProfileData getInstance];
        return [[lpd findAllprofiles] count];
    }
}


-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.loaner.selectedSegmentIndex==0)
    {
        SavingsProfileData*spd=[SavingsProfileData getInstance];
        SavingsProfile* currentProfile=[[spd findAllprofiles] objectAtIndex:row];
        return currentProfile.name;
        
    }
    else
    {
        LoanProfileData*lpd=[LoanProfileData getInstance];
        LoanProfile* currentProfile=[[lpd findAllprofiles] objectAtIndex:row];
        return currentProfile.name;
    }

}

#pragma mark- PickerView Delegate
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (self.loaner.selectedSegmentIndex==0)
    {
        SavingsProfileData*spd=[SavingsProfileData getInstance];
        SavingsProfile* currentProfile=[[spd findAllprofiles] objectAtIndex:row];
        [self.theCustomer setValue:[NSNumber numberWithInt:currentProfile.sPId] forKey:@"profileID"];
        
    }
    else
    {
        LoanProfileData*lpd=[LoanProfileData getInstance];
        LoanProfile* currentProfile=[[lpd findAllprofiles] objectAtIndex:row];
        [self.theCustomer setValue:[NSNumber numberWithInt:currentProfile.lPId] forKey:@"profileID"];

       
    }
    
    NSLog(@"profile chosen:%@",self.theCustomer);
}
@end
