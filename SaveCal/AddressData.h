//
//  AddressData.h
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface AddressData : NSObject



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSDictionary* currentAddress;
+(AddressData*) getInstance;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


-(NSDictionary*)findByID_id:(int)adID;//dictionary that will describe customers and their attributes
-(NSDictionary*)findBy_customerid:(int)customerid;//dictionary that will describe customers and their attributes

-(NSMutableArray*)findAllAddresss;//array of type Address
- (void)insertAddress_ad:(NSDictionary*)ad ;
- (void)updateAddress_ad:(NSDictionary*)ad;
- (void)removeAddress_ad:(NSDictionary*)ad;

@end
