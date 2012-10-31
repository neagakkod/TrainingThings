//
//  ViewAllLoanProfilesController.h
//  SaveCal
//
//  Created by user on 10/22/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ViewAllLoanProfilesController : UITableViewController


@property(strong,nonatomic)NSArray*theLoanProfiles;
@property (nonatomic)BOOL onlineMode;
@property (strong,nonatomic)UIView*overlayView;
@property (strong, nonatomic)UIActivityIndicatorView* actView;
- (IBAction)goOnline:(id)sender;
-(IBAction)backToMenu:(id)sender;
-(IBAction)showDelete:(id)sender;
@end
