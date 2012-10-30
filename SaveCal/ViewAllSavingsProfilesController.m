//
//  ViewAllSavingsProfilesController.m
//  SaveCal
//
//  Created by user on 10/23/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "ViewAllSavingsProfilesController.h"
#import "SavingsProfileData.h"
#import "SavingsViewController.h"
//#import "SavingsProfileFetcher.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT,0)
@interface ViewAllSavingsProfilesController ()

@end

@implementation ViewAllSavingsProfilesController
@synthesize theSavingsProfiles;
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
    
    SavingsProfileData* spd=[SavingsProfileData getInstance];
    self.theSavingsProfiles=[spd findAllprofiles];
     NSLog(@"Displaying all savings profiles");
    NSLog(@"Total Savings:%i",[self.theSavingsProfiles count]);
    
    self.onlineMode=NO;
   


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    if (!self.onlineMode)
    {
        SavingsProfileData* spd=[SavingsProfileData getInstance];
        self.theSavingsProfiles= [spd findAllprofiles];
        NSLog(@"Displaying all savings profiles");
        NSLog(@"Total Savings:%i",[self.theSavingsProfiles count]);
        
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.theSavingsProfiles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    SavingsProfile* currentSp=[self.theSavingsProfiles objectAtIndex:indexPath.row];
    
    cell.textLabel.text=currentSp.name;
    
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
        SavingsProfileData* spd=[SavingsProfileData getInstance];
        self.theSavingsProfiles=[spd findAllprofiles];
        
        SavingsProfile* deleted= [self.theSavingsProfiles objectAtIndex:indexPath.row];//[spd findByID_id:indexPath.row];
        [spd removeSavingsProfile_sp:deleted];
        
        
         self.theSavingsProfiles=[spd findAllprofiles];
        
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
- (IBAction)showOnlineProfiles:(id)sender
{
    if (self.onlineMode)
    {
        SavingsProfileData* spd=[SavingsProfileData getInstance];
        self.theSavingsProfiles= [spd findAllprofiles];
        [[self.toolbarItems objectAtIndex:0] setTitle:@"Profiles on Server"];
        [self.tableView reloadData];
        self.onlineMode=NO;
          [[self.toolbarItems objectAtIndex:2] setEnabled:YES];

    }
    else
    {
        [self findAllprofiles];
        [[self.toolbarItems objectAtIndex:0] setTitle:@"Profiles on Phone"];
    }
    
    
   //while (!spf.doneSignal){/*wait*/};
   // self.theSavingsProfiles=[spf getAllProfiles];
    
}

-(IBAction)showDelete:(id)sender
{
    if (self.tableView.editing == NO)
    {
        NSMutableArray* tb=[[ NSMutableArray alloc] initWithArray:  self.toolbarItems];
        [tb replaceObjectAtIndex:2 withObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(showDelete:)]];
        [self setToolbarItems:tb];

        self.tableView.editing = YES;
    }
    else
    {
        
        NSMutableArray* tb=[[ NSMutableArray alloc] initWithArray:  self.toolbarItems];
        [tb replaceObjectAtIndex:2 withObject:[[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(showDelete:)]];
        [self setToolbarItems:tb];
        
      
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"identifier:%@",segue.identifier);
    NSString* edit=[NSString stringWithFormat:@"edit"];
    if ([segue.identifier isEqualToString:edit])
    {
        SavingsViewController *detailViewController =segue.destinationViewController;
//        
        SavingsProfile*currentSp=[self.theSavingsProfiles objectAtIndex:[self.tableView indexPathForSelectedRow].row ];
        
        SavingsProfileData*spd= [SavingsProfileData getInstance];
        spd.currentProfile=currentSp;
        [detailViewController setSp: currentSp];
        
           }
}
////////online
#pragma mark online methods

-(void)findAllprofiles
{
    NSString * url= @"http://localhost:8888/moneyNStuffSync/index.php/api/SavingsProfile";
    
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
    NSArray*allProfiles=jsonData;//self.theSavingsProfiles;
    
    for (int i=0; i<[allProfiles count]; i++)
    {
        [results addObject: [[SavingsProfile alloc]initCreateSavingsProfile_name:[[allProfiles objectAtIndex:i] objectForKey:@"name"] startingWith:[[[allProfiles objectAtIndex:i] objectForKey:@"startingWith"] doubleValue] savingsTime:[[[allProfiles objectAtIndex:i] objectForKey:@"savingsTime"] doubleValue] equalDepositAmount:[[[allProfiles objectAtIndex:i] objectForKey:@"equalDepositsAmount"] doubleValue] yearlyIntRate:[[[allProfiles objectAtIndex:i] objectForKey:@"yearlyInterestRate"] doubleValue]  goal:[[[allProfiles objectAtIndex:i] objectForKey:@"goal"] doubleValue] ]];
    }
    
    self.theSavingsProfiles=results;
    [[self.toolbarItems objectAtIndex:2] setEnabled:NO];
    [self setOnlineMode: YES];
    [self.tableView reloadData];

    
}


@end
