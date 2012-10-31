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
@synthesize overlayView;
@synthesize actView;
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
    
    self.overlayView= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.tableView.frame.size.height)];
    [self.overlayView setHidden:YES];
    self.overlayView.backgroundColor=[UIColor blackColor];
    
    [self.view addSubview:self.overlayView];

    //activity indicator view
    self.actView=[[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2-50, self.view.frame.size.height/2-50, 100, 100)];
    
    [self.actView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    [self.overlayView addSubview:self.actView];
    //////////////////
    
    
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
    
    
    UILabel*loadingOnline=[[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-60,self.actView.center.y-100 , self.view.frame.size.width/2 , self.view.frame.size.width/4)];
    loadingOnline.text=@"Fetching Info";
    [loadingOnline setTextColor:[UIColor whiteColor]];
    [loadingOnline setBackgroundColor:[UIColor clearColor]];
    [self.overlayView addSubview:loadingOnline];
    
    
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
       // NSMutableArray* too= [[NSMutableArray alloc] init];
         NSMutableArray* too=[[ NSMutableArray alloc] initWithArray:  self.toolbarItems];
//        too[1]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
     too[2]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showDelete:)];
        [[self.toolbarItems objectAtIndex:0] setEnabled:NO];
        [self setToolbarItems:too];
        //self.navigationItem.leftBarButtonItem = nil;
        //self.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showDelete:)];
        self.tableView.editing = YES;
    }
    else
    {
         [[self.toolbarItems objectAtIndex:0] setEnabled:YES];
        NSMutableArray* too= [[ NSMutableArray alloc] initWithArray:  self.toolbarItems];       //  too[0]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
        too[2]= [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDelete:)];
        
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
         [self.overlayView setHidden:NO];
         [self.actView startAnimating];
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
         [[self.toolbarItems objectAtIndex:2] setEnabled:YES];
        
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
    if (response!=nil)
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
                LoanProfile* newOne=[[LoanProfile alloc] initCreateLoanProfile_name:[[current objectAtIndex:i ] valueForKey:@"name"] loanAmount:[[[current objectAtIndex:i ]  valueForKey:@"loanAmount"]  doubleValue]  payBackTime: [[[current objectAtIndex:i ]  valueForKey:@"payBackTime"] intValue] equalPaymentAmount:[[[current objectAtIndex:i ]  valueForKey:@"equalPaymentAmount"] doubleValue]  yearlyIntRate:[[[current objectAtIndex:i ]  valueForKey:@"yearlyIntRate"] doubleValue]];
                [newOne setCompounding:[[[current objectAtIndex:i] valueForKey:@"compounding"] intValue]];
                [newOne setPaymentFrequency:[[[current objectAtIndex:i] valueForKey:@"paymentFrequency"] intValue]];
                [newOne setLPId:-1];
               [results addObject:newOne];
            }
            
            self.theLoanProfiles=results;
            [[self.toolbarItems objectAtIndex:2] setEnabled:NO];
            [self setOnlineMode: YES];
            [self.tableView reloadData];
    }
    else
    {
        UIAlertView*alret=[[UIAlertView alloc]initWithTitle:@"Connection Issues" message:@"Wow! We are experiencing server issues. Try again later" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alret show];
        self.onlineMode=NO;
        [[self.toolbarItems objectAtIndex:2] setEnabled:YES];
    }
    [self.overlayView setHidden:YES];
    [self.actView stopAnimating];
    
}


@end
