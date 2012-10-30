//
//  ViewAllCusotmerCotnroller.h
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewAllCusotmerCotnroller : UITableViewController
{
    @private NSDictionary*addressForChosen;
}
- (IBAction)backToMenu:(id)sender;
-(IBAction)goOnline:(id)sender;
@property (strong,nonatomic) NSMutableArray*theCustomers;
@property (nonatomic) BOOL onlineMode;
@end
