//
//  SavingsProfileData.h
//  SaveCal
//
//  Created by user on 10/22/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "SavingsProfile.h"

@interface SavingsProfileData : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) SavingsProfile* currentProfile;
+(SavingsProfileData*) getInstance;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
-(void)setBoundsOnInterest:(UISlider *)slider;
-(SavingsProfile*)findByID_id:(int)spID;
-(NSMutableArray*)findAllprofiles;//array of type SavingsProfile
- (void)insertSavingsProfile_sp:(SavingsProfile*)sp;
- (void)updateSavingsProfile_sp:(SavingsProfile*)sp;
- (void)removeSavingsProfile_sp:(SavingsProfile*)sp;



@end
