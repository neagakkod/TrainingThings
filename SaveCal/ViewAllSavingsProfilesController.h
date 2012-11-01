//
//  ViewAllSavingsProfilesController.h
//  SaveCal
//
//  Created by user on 10/23/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAllSavingsProfilesController : UITableViewController
@property(strong,nonatomic)NSArray*theSavingsProfiles;
@property (nonatomic)BOOL onlineMode;
@property (strong,nonatomic)UIView*overlay;
@property (strong, nonatomic)UIActivityIndicatorView* actView;
- (IBAction)showOnlineProfiles:(id)sender;
-(IBAction)showDelete:(id)sender;
-(IBAction)backToMenu:(id)sender;
@end
