//
//  ViewAllCusotmerCotnroller.m
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.


#import "ViewAllCusotmerCotnroller.h"
#import "MainMenuViewController.h"
#import "CustomerViewController.h"
#import "CustomerData.h"
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
@interface ViewAllCusotmerCotnroller ()

@end

@implementation ViewAllCusotmerCotnroller
@synthesize theCustomers;
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
    CustomerData* cd= [CustomerData getInstance];
    NSLog(@"max cid:%i",   [cd maxcID]);
   self.theCustomers= [cd findCustomers];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}
-(void)viewDidAppear:(BOOL)animated
{
    CustomerData* cd= [CustomerData getInstance];
   
    self.theCustomers= [cd findCustomers];

    [self.tableView reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.theCustomers count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text=[NSString stringWithFormat:@"%@ %@",[[self.theCustomers objectAtIndex:indexPath.row] objectForKey:@"firstName"],[[self.theCustomers objectAtIndex:indexPath.row] objectForKey:@"lastName"] ];
    
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

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    //chosenCustomer
    if ([segue.identifier isEqualToString:@"chosenCustomer"])
    {
        if (self.onlineMode) {
            dispatch_sync(kBgQueue, ^
                          {
                              [self findChosenCustomerAddress];
                          });
            dispatch_sync(kBgQueue, ^{
                CustomerViewController* next=segue.destinationViewController;
                CustomerData*cd=[CustomerData getInstance];
                [cd setCurrentCustomer:[self.theCustomers objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
                [cd.currentCustomer setValue:0 forKey:@"cid"];
                [next setTheCustomer:cd.currentCustomer];
                [next setTheAddress:addressForChosen];
            });

        }
        else
        {
            CustomerViewController* next=segue.destinationViewController;
            CustomerData*cd=[CustomerData getInstance];
            [cd setCurrentCustomer:[self.theCustomers objectAtIndex:[self.tableView indexPathForSelectedRow].row]];
            
            [next setTheCustomer:cd.currentCustomer];
            [next setTheAddress:addressForChosen];
        }
        
     
               
    }
    
    
}
-(IBAction)backToMenu:(id)sender
{
    
    MainMenuViewController*menu=[self.storyboard instantiateViewControllerWithIdentifier:@"mainmenu"];  //[[MainMenuViewController alloc] init];
    [self presentModalViewController:menu animated:YES];
    //  [self.navigationController.navigationBar popNavigationItemAnimated:YES];
    
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
        CustomerData* lpd=[CustomerData getInstance];
        self.theCustomers= [lpd findCustomers];
        [[self.toolbarItems objectAtIndex:0] setTitle:@"Profiles on Server"];
        self.onlineMode=NO;
        [self.tableView reloadData];
        
    }
    
}

-(void)findChosenCustomerAddress
{
    NSDictionary * chosenCustomer=[self.theCustomers objectAtIndex:[self.tableView indexPathForSelectedRow].row];
    NSString * url= [NSString stringWithFormat:@"http://localhost:8888/moneyNStuffSync/index.php/api/Customer/%i",[[chosenCustomer objectForKey:@"cid"] intValue ]];
    
    NSLog(@"%@",url);
    NSURL* requestURL= [NSURL URLWithString:url];
    
    dispatch_sync(kBgQueue, ^
                   {
                       NSData * data= [NSData dataWithContentsOfURL:requestURL];
                       [self performSelectorOnMainThread:@selector(getAddress:) withObject: data waitUntilDone:YES];
                   });
    
}
-(void)findAllprofiles
{
    NSString * url= @"http://localhost:8888/moneyNStuffSync/index.php/api/Customer/";
    
    NSLog(@"%@",url);
    NSURL* requestURL= [NSURL URLWithString:url];
    
    dispatch_async(kBgQueue, ^
                   {
                       NSData * data= [NSData dataWithContentsOfURL:requestURL];
                       [self performSelectorOnMainThread:@selector(dataFetched:) withObject: data waitUntilDone:YES];
                   });
    
}
-(IBAction)getAddress: (NSData*) response
{
    
    NSError* error;
    NSArray* jsonData=[NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    
    if(error)
    {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    
    NSLog(@"data: %@",jsonData);
    
    addressForChosen=  [[NSDictionary alloc] initWithObjectsAndKeys:[[jsonData objectAtIndex:1] valueForKey:@"city"], @"city",
     [[jsonData objectAtIndex:1] valueForKey:@"country"],@"country",
     [[jsonData objectAtIndex:1] valueForKey:@"customerID"],@"customerID",
     [[jsonData objectAtIndex:1] valueForKey:@"region"],@"region",
     [[jsonData objectAtIndex:1] valueForKey:@"streetAddress"],@"streetAddress",
     [[jsonData objectAtIndex:1] valueForKey:@"zipcode"],@"zipcode",
                        nil];


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
    NSArray*allData=jsonData;
    
    for (int i=0; i<[allData count]; i++)
    {
     
      [ results addObject: [[NSMutableDictionary alloc] initWithObjectsAndKeys:[[allData objectAtIndex:i] valueForKey:@"firstName"], @"firstName",
        [[allData objectAtIndex:i] valueForKey:@"lastName"],@"lastName",
       [[allData objectAtIndex:i] valueForKey:@"cid"],@"cid",
        [[allData objectAtIndex:i] valueForKey:@"loaner"],@"loaner",
        [[allData objectAtIndex:i] valueForKey:@"phoneNumber"],@"phone",
        [[allData objectAtIndex:i] valueForKey:@"profileID"],@"profileID",
       nil]];

    }
    
    self.theCustomers=results;
   // [[self.toolbarItems objectAtIndex:2] setEnabled:NO];
    [self setOnlineMode: YES];
    [self.tableView reloadData];
    
    
}


@end
