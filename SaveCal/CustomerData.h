//
//  CustomerData.h
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CustomerData : NSObject




@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSDictionary* currentCustomer;
+(CustomerData*) getInstance;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


-(NSDictionary*)findByID_id:(int)lpID;//dictionary that will describe customers and their attributes
-(NSMutableArray*)findCustomers;//array of type LoanProfile
- (void)insertCustomer_c:(NSDictionary*)c;
- (void)updateCustomer_c:(NSDictionary*)c;
- (void)removeCustomer_c:(NSDictionary*)c;
-(int) maxcID;




@end
