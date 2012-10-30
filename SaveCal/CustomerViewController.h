//
//  CustomerViewController.h
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomerViewController : UITableViewController<UITextFieldDelegate,UIActionSheetDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
@property (strong,nonatomic) UIActionSheet* aac;
@property (strong,nonatomic) IBOutlet UISegmentedControl* loaner;
@property (strong, nonatomic) IBOutlet UITextField *firstName;
@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong,nonatomic) NSDictionary* theCustomer;
@property (strong,nonatomic) NSDictionary* theAddress;
@property (strong, nonatomic) IBOutlet UITextField *streetAddress;
@property (strong, nonatomic) IBOutlet UITextField *city;
@property (strong, nonatomic) IBOutlet UITextField *region;
@property (strong, nonatomic) IBOutlet UITextField *zipCode;
@property (strong, nonatomic) IBOutlet UITextField *phone;

- (IBAction)addOrSavePressed:(id)sender;

- (IBAction)loadProfile:(id)sender;
@end
