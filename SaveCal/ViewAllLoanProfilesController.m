//
//  ViewAllLoanProfilesController.m
//  SaveCal
//
//  Created by user on 10/22/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "ViewAllLoanProfilesController.h"
#import "LoanDisplayViewController.h"
#import "MainMenuViewController.h"
#import "LoanProfileData.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
@interface ViewAllLoanProfilesController ()

@end

@implementation ViewAllLoanProfilesController
@synthesize theLoanProfiles;
@synthesize onlineMode;
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
    self.theLoanProfiles= [lpd findAllprofiles];
    
 
      NSLog(@"Displaying all loan profiles");
    self.onlineMode=NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated
{
   
    [super viewWillAppear:animated];
    if(! self.onlineMode)
    {
    LoanProfileData* lpd=[LoanProfileData getInstance];
    self.theLoanProfiles= [lpd findAllprofiles];

    [self.tableView reloadData];
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
    // tableView.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.theLoanProfiles count] ;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
    // Configure the cell...
    LoanProfile*currentLp=[self.theLoanProfiles objectAtIndex:indexPath.row];
    cell.textLabel.text= currentLp.name ;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        LoanProfileData* lpd=[LoanProfileData getInstance];
        self.theLoanProfiles=[lpd findAllprofiles];
        
        LoanProfile* deleted= [self.theLoanProfiles objectAtIndex:indexPath.row];
        [lpd removeLoanProfile_lp:deleted];
        
        
        self.theLoanProfiles=[lpd findAllprofiles];

        
        
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}



-(IBAction)backToMenu:(id)sender
{
    
    MainMenuViewController*menu=[self.storyboard instantiateViewControllerWithIdentifier:@"mainmenu"];  //[[MainMenuViewController alloc] init];
   [self presentModalViewController:menu animated:YES];
  //  [self.navigationController.navigationBar popNavigationItemAnimated:YES];
    
}


-(IBAction)showDelete:(id)sender
{
    if (self.tableView.editing == NO)
    {
        NSMutableArray* too= [[NSMutableArray alloc] init];
        too[0]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
      too[1]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showDelete:)];
        
        [self setToolbarItems:too];
        //self.navigationItem.leftBarButtonItem = nil;
        //self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showDelete:)];
        self.tableView.editing = YES;
    }
    else
    {
        NSMutableArray* too= [[NSMutableArray alloc] init];
        
         too[0]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        too[1]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDelete:)];
        
        [self setToolbarItems:too];

        
//        self.navigationItem.leftBarButtonItem = nil;
//        self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDelete:)];
        self.tableView.editing = NO;
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

#pragma mark - Table view delegate



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
   
//    DisplayViewController *detailViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"edit"];
    // [[DisplayViewController alloc] init];
    
    //detailViewController storyboard
    // initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
//     [self.navigationController pushViewController:detailViewController animated:YES];
    
    
    
}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"identifier:%@",segue.identifier);
    NSString* edit=[NSString stringWithFormat:@"edit"];
    if ([segue.identifier isEqualToString:edit])
    {
        LoanDisplayViewController *detailViewController =segue.destinationViewController;
    
        LoanProfile*currentLp=[self.theLoanProfiles objectAtIndex:[self.tableView indexPathForSelectedRow].row ];
        detailViewController.lp =currentLp;
        
    }
    
    
     [self.navigationController.toolbar setHidden:NO];
}

////////online
#pragma mark online methods
- (IBAction)goOnline:(id)sender
{
    if ( !self.onlineMode)
     {
        [self findAllprofiles];
         [[self.toolbarItems objectAtIndex:0] setTitle:@"Profiles on Phone"];

    }
    else
    {
        LoanProfileData* lpd=[LoanProfileData getInstance];
        self.theLoanProfiles= [lpd findAllprofiles];
          [[self.toolbarItems objectAtIndex:0] setTitle:@"Profiles on Server"];
        self.onlineMode=NO;
        [self.tableView reloadData];
        
    }

}
-(void)findAllprofiles
{
    NSString * url= @"http://localhost:8888/moneyNStuffSync/index.php/api/LoanProfile";
    
    NSLog(@"%@",url);
    NSURL* requestURL= [NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^
                   {
                       NSData * data= [NSData dataWithContentsOfURL:requestURL];
                       [self performSelectorOnMainThread:@selector(dataFetched:) withObject: data waitUntilDone:YES];
                   });
    
}

-(IBAction) dataFetched: (NSData*) response
{
    NSError* error;
    NSArray* jsonData=[NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    if(error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    
    NSLog(@"data: %@",jsonData);
    
    //////////
    
    NSMutableArray* results=[[NSMutableArray alloc] init];
    NSArray*current=jsonData;//self.theSavingsProfiles;
    
    for (int i=0; i<[current count]; i++)
    {
       [results addObject:[[LoanProfile alloc] initCreateLoanProfile_name:[[current objectAtIndex:i ] valueForKey:@"name"] loanAmount:[[[current objectAtIndex:i ]  valueForKey:@"loanAmount"]  doubleValue]  payBackTime: [[[current objectAtIndex:i ]  valueForKey:@"payBackTime"] intValue] equalPaymentAmount:[[[current objectAtIndex:i ]  valueForKey:@"equalPaymentAmount"] doubleValue]  yearlyIntRate:[[[current objectAtIndex:i ]  valueForKey:@"yearlyIntRate"] doubleValue]]];
    }
    
    self.theLoanProfiles=results;
    [[self.toolbarItems objectAtIndex:2] setEnabled:NO];
    [self setOnlineMode: YES];
    [self.tableView reloadData];
    
    
}


@end
