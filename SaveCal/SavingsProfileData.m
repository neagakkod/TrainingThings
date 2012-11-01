//
//  SavingsProfileData.m
//  SaveCal
//
//  Created by user on 10/22/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "SavingsProfileData.h"



@interface SavingsProfileData(private)
-(NSManagedObject*)findByID:(int)lpID;
-(NSArray*)findAll;//array of NSManagedObjects
-(void) remeove:(int)lpID;
-(int)getMaxID;
-(void)updateSavingsProfile_id:(int)lpID name:(NSString*)name startingWith:(double)startingWith savingsTime:(int)savingsTime equalDepositAmount:(double)equalDepositAmount yearlyIntRate:(float)yearlyIntRate goal:(double)goal ;
-(void)insertSavingsProfile_name:(NSString*)name startingWith:(double)startingWith savingsTime:(int)savingsTime equalDepositAmount:(double)equalDepositAmount yearlyIntRate:(float)yearlyIntRate goal:(double)goal ;
@end
@implementation SavingsProfileData

@synthesize managedObjectContext=_managedObjectContext;
@synthesize managedObjectModel=_managedObjectModel;
@synthesize persistentStoreCoordinator=_persistentStoreCoordinator;



-(id)init
{
    self = [super init];
    if (self)
    {
        //assigning managedObjectModel
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"mom"] ;
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        
        
        //assigning the managedObjectContext
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator] ;
        _managedObjectContext=_managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
        
        
        
    }
    return self;
    
}


#pragma mark singleton things

static SavingsProfileData* instance=nil;

+(SavingsProfileData*)getInstance
{
    if(instance==nil)
    {
        instance=[[SavingsProfileData alloc] init];
    }
    return instance;
}


#pragma mark - Core Data stack
///////////////////////////
///core data section

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}



// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator] ;
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"] ;
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil)
    {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"SaveCal.sqlite"] ;
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]] ;
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark private methods
-(NSManagedObject*)findByID:(int)lpID
{
    
    NSEntityDescription* loanProfileEntity= [NSEntityDescription entityForName:@"SavingsProfile" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(spid= %i)",lpID ];
    // NSSortDescriptor * sorting= [NSSortDescriptor sort] used for sorting
    
    [request setEntity:loanProfileEntity];
    [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    if ([objects count]>0)
    {
        return [objects objectAtIndex:0];
    }
    else
        return nil;
    
}


-(NSArray*)findAll//array of NSManagedObjects
{
    
    NSEntityDescription* loanProfileEntity= [NSEntityDescription entityForName:@"SavingsProfile" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
    
    // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
    
    [request setEntity:loanProfileEntity];
    //  [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
    
}

-(void)insertSavingsProfile_name:(NSString*)name startingWith:(double)startingWith savingsTime:(int)savingsTime equalDepositAmount:(double)equalDepositAmount yearlyIntRate:(float)yearlyIntRate goal:(double)goal;

{
    
    NSManagedObject* newSavingsProfile= [NSEntityDescription insertNewObjectForEntityForName:@"SavingsProfile" inManagedObjectContext:_managedObjectContext];
    
 
    [newSavingsProfile setValue:name forKey:@"name"];
    [newSavingsProfile setValue:[NSNumber numberWithInt:([self getMaxID]+1 )] forKey:@"spid"];
    [newSavingsProfile setValue:[NSNumber numberWithDouble:yearlyIntRate ]forKey:@"yearlyInterestRate"];
    [newSavingsProfile setValue:[NSNumber numberWithDouble:equalDepositAmount ] forKey:@"equalDepositsAmount"];
    [newSavingsProfile setValue:[NSNumber numberWithInt:savingsTime] forKey:@"savingsTime"];
    
    [newSavingsProfile setValue:[NSNumber numberWithDouble:goal] forKey:@"goal"];
     [newSavingsProfile setValue:[NSNumber numberWithDouble:startingWith] forKey:@"startingWith"];
    
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"profile save failed");
    }
    else
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"Congrats!" message:[NSString stringWithFormat:@"Woah.You Inserted With Success!"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"profile saved");
    }

    
}

-(int)getMaxID
{
    if ([[self findAll] count]>0)
    {
        NSEntityDescription* customerEntity= [NSEntityDescription entityForName:@"SavingsProfile" inManagedObjectContext:_managedObjectContext];
        NSFetchRequest* request= [[NSFetchRequest alloc] init];
        //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
        
        // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
        
        [request setEntity:customerEntity];
        //  [request setPredicate:predicate];
        // Specify that the request should return dictionaries.
        [request setResultType:NSDictionaryResultType];
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"spid"];
        NSExpression *maxIDExpression = [NSExpression expressionForFunction:@"max:"
                                                                  arguments:[NSArray arrayWithObject:keyPathExpression]];
        
        NSExpressionDescription *expressionDescription = [[NSExpressionDescription alloc] init];
        [expressionDescription setName:@"maxID"];
        [expressionDescription setExpression:maxIDExpression];
        [expressionDescription setExpressionResultType:NSInteger16AttributeType];
        
        // Set the request's properties to fetch just the property represented by the expressions.
        [request setPropertiesToFetch:[NSArray arrayWithObject:expressionDescription]];
        
        
        NSError * error ;
        NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
        
        NSLog(@"%@",[objects objectAtIndex:0]);
        int result= [[[objects objectAtIndex:0] valueForKey:@"maxID"] intValue];
        return result;
    }
    else
        return 0;
    
    
}

-(void)updateSavingsProfile_id:(int)lpID name:(NSString*)name startingWith:(double)startingWith savingsTime:(int)savingsTime equalDepositAmount:(double)equalDepositAmount yearlyIntRate:(float)yearlyIntRate goal:(double)goal ;

{
    NSManagedObject* newSavingsProfile= [self findByID:lpID];
      
    
    [newSavingsProfile setValue:name forKey:@"name"];
    [newSavingsProfile setValue:[NSNumber numberWithInt:lpID] forKey:@"spid"];
    [newSavingsProfile setValue:[NSNumber numberWithDouble:yearlyIntRate ]forKey:@"yearlyInterestRate"];
    [newSavingsProfile setValue:[NSNumber numberWithDouble:equalDepositAmount ] forKey:@"equalDepositsAmount"];
    [newSavingsProfile setValue:[NSNumber numberWithInt:savingsTime] forKey:@"savingsTime"];
    
    [newSavingsProfile setValue:[NSNumber numberWithDouble:goal] forKey:@"goal"];
    [newSavingsProfile setValue:[NSNumber numberWithDouble:startingWith] forKey:@"startingWith"];
    
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"profile save failed");
    }
    else
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"update succesful" message:[NSString stringWithFormat:@"Woah.Your Update Was succesful! "] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"customer saved");
    }

    
}
-(void)remeove:(int)lpID
{
    [self.managedObjectContext deleteObject:[self findByID:lpID]];
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"profile delete failed");
    }
    else
    {
        NSLog( @"profile deleted");
    }

   
}
#pragma mark public methods
-(void)setBoundsOnInterest:(UISlider *)slider
{
    double maxIntValue=[[[NSUserDefaults standardUserDefaults] stringForKey:@"maxItrVal"] doubleValue];
    double minIntValue=[[[NSUserDefaults standardUserDefaults] stringForKey:@"minItrVal"] doubleValue];
    
    NSLog(@"maxitrval:%f",maxIntValue);
    NSLog(@"maxitrval:%f",minIntValue);
    
    if (maxIntValue>0&&minIntValue>0)
    {
        if (minIntValue<maxIntValue)
        {
            [slider setMinimumValue:(minIntValue/100)];
            [slider setMaximumValue:(maxIntValue/100)];
            
        }
    }
    
    
}

-(void)insertSavingsProfile_sp:(SavingsProfile *)sp
{
    [self insertSavingsProfile_name:sp.name startingWith:sp.startingWith savingsTime:sp.savingsTime equalDepositAmount:sp.equalDepositAmount yearlyIntRate:sp.interestRate goal:sp.goal];
}

-(NSMutableArray *)findAllprofiles
{
    NSArray* kindOfRawData=  [self findAll];
    NSMutableArray* result= [[NSMutableArray alloc]init];
    SavingsProfile*element;
    for (int i=0; i<[kindOfRawData count]; i++)
    {//savingsTime
        NSManagedObject* current=[kindOfRawData objectAtIndex:i];
        element=[[SavingsProfile alloc] initCreateSavingsProfile_name:[current valueForKey:@"name"] startingWith:[[current valueForKey:@"startingWith"]doubleValue]  savingsTime:[[current valueForKey:@"savingsTime"] intValue] equalDepositAmount:[[current valueForKey:@"equalDepositsAmount"] doubleValue] yearlyIntRate:[[current valueForKey:@"yearlyInterestRate"] doubleValue] goal:[[current valueForKey:@"goal"] doubleValue]];
        [element setSPId:[[current valueForKey:@"spid"] intValue]];
        [result addObject:element ];
        
    }
    
    return result;
}

-(SavingsProfile *)findByID_id:(int)lpID
{
    NSManagedObject* current=[self findByID:lpID];
    if (current!=nil)
    {
        SavingsProfile * element=[[SavingsProfile alloc] initCreateSavingsProfile_name:[current valueForKey:@"name"] startingWith:[[current valueForKey:@"startingWith"]doubleValue]  savingsTime:[[current valueForKey:@"savingsTime"] intValue] equalDepositAmount:[[current valueForKey:@"equalDepositsAmount"] doubleValue] yearlyIntRate:[[current valueForKey:@"yearlyInterestRate"] doubleValue] goal:[[current valueForKey:@"goal"] doubleValue]];
        [element setSPId:[[current valueForKey:@"spid"] intValue]];
        return element;
    }
    else
        return nil;

   
}

-(void)updateSavingsProfile_sp:(SavingsProfile *)sp
{
    [self updateSavingsProfile_id:sp.sPId name:sp.name startingWith:sp.startingWith savingsTime:sp.savingsTime equalDepositAmount:sp.equalDepositAmount yearlyIntRate:sp.interestRate goal:sp.goal];
}

-(void) removeSavingsProfile_sp:(SavingsProfile *)sp
{
    [self remeove:sp.sPId];
}

@end
