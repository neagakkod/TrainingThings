//
//  LoanProfileData.h
//  SaveCal
//
//  Created by user on 10/21/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LoanProfile.h"

@interface LoanProfileData : NSObject



@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) LoanProfile* currentProdile;
+(LoanProfileData*) getInstance;

-(void)setBoundsOnInterest:(UISlider*)slider;
- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(int)getMaxID;
-(LoanProfile*)findByID_id:(int)lpID;
-(NSMutableArray*)findAllprofiles;//array of type LoanProfile
- (void)insertLoanProfile_lp:(LoanProfile*)lp;
- (void)updateLoanProfile_lp:(LoanProfile*)lp;
- (void)removeLoanProfile_lp:(LoanProfile*)lp;

@end
