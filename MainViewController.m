//
//  MainViewController.m
//  SaveCal
//
//  Created by user on 10/31/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "MainViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationController.navigationBar setHidden:YES];

}
-(void)viewDidAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];

}
-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController.navigationBar setHidden:YES];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    UITabBarController* valp=segue.destinationViewController;
    
    NSMutableArray* realOrder= [[NSMutableArray alloc]initWithArray:valp.viewControllers];
    UIViewController* i0=[realOrder objectAtIndex:2];
    UIViewController* i2=[realOrder objectAtIndex:1];
    
    realOrder[1]=realOrder[0];
    realOrder[0]=i0;
    realOrder[2]=i2;
    
    [valp setViewControllers:realOrder];
    
    
    if ([segue.identifier isEqualToString:@"manageLP"])
    {
        NSLog(@"%@",segue.identifier);
        [valp setSelectedIndex:1];
    }
    else if ([segue.identifier isEqualToString:@"manageSP"])
    {
        NSLog(@"%@",segue.identifier);
        [valp setSelectedIndex:2];
    }
    else
    {
        NSLog(@"%@",segue.identifier);
        [valp setSelectedIndex:0];
    }
    
}

@end
