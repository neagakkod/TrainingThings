//
//  LoanProfileData.m
//  SaveCal
//
//  Created by user on 10/21/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "LoanProfileData.h"


@interface LoanProfileData(private)
-(NSManagedObject*)findByID:(int)lpID;
-(NSArray*)findAll;//array of NSManagedObjects
-(void) remeove:(int)lpID;
//-(int)getMaxID;
-(void)updateLoanProfile_id:(int)lpID name:(NSString*)name loanAmount:(double)loanAmount payBackTime:(int)payBackTime equalPaymentAmount:(double)equalPaymentAmount yearlyIntRate:(float)yearlyIntRate ;
-(void)insertLoanProfile_name:(NSString*)name loanAmount:(double)loanAmount payBackTime:(int)payBackTime equalPaymentAmount:(double)equalPaymentAmount yearlyIntRate:(float)yearlyIntRate ;
@end
@implementation LoanProfileData

@synthesize currentProdile;
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

//-(LoanProfile *)currentProdile
//{
//    if (self.currentProdile==nil) {
//        self.currentProdile= [[LoanProfile alloc] init];
//        
//    }
//    return self.currentProdile;
//}


#pragma mark singleton things

static LoanProfileData* instance=nil;

+(LoanProfileData*)getInstance
{
    if(instance==nil)
    {
        instance=[[LoanProfileData alloc] init];
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
    
    NSEntityDescription* loanProfileEntity= [NSEntityDescription entityForName:@"LoanProfile" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
    // NSSortDescriptor * sorting= [NSSortDescriptor sort] used for sorting

    [request setEntity:loanProfileEntity];
    [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return [objects objectAtIndex:0];
 }


-(NSArray*)findAll//array of NSManagedObjects
{
    
    NSEntityDescription* loanProfileEntity= [NSEntityDescription entityForName:@"LoanProfile" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
   
   // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending

    [request setEntity:loanProfileEntity];
  //  [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
    
}

-(void)insertLoanProfile_name:(NSString*)name loanAmount:(double)loanAmount payBackTime:(int)payBackTime equalPaymentAmount:(double)equalPaymentAmount yearlyIntRate:(float)yearlyIntRate
{
   int idForNewProfile=[self getMaxID]+1 ;
    NSManagedObject* newLoanProfile= [NSEntityDescription insertNewObjectForEntityForName:@"LoanProfile" inManagedObjectContext:_managedObjectContext];
 
    
    [newLoanProfile setValue:name forKey:@"name"];
    [newLoanProfile setValue:[NSNumber numberWithInt:(idForNewProfile)] forKey:@"lpid"];
    [newLoanProfile setValue:[NSNumber numberWithDouble:yearlyIntRate ]forKey:@"yearlyIntRate"];
    [newLoanProfile setValue:[NSNumber numberWithDouble:equalPaymentAmount ] forKey:@"equalPaymentAmount"];
    [newLoanProfile setValue:[NSNumber numberWithInt:payBackTime] forKey:@"payBackTime"];
    
    [newLoanProfile setValue:[NSNumber numberWithDouble:loanAmount] forKey:@"loanAmount"];
   
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
                [alert show];
        NSLog( @"contact save failed");
    }
    else
    {
          NSLog( @"contact saved");
          }
    

}
 
-(int)getMaxID
{
    if ([[self findAll] count]>0)
        {
            NSEntityDescription* customerEntity= [NSEntityDescription entityForName:@"LoanProfile" inManagedObjectContext:_managedObjectContext];
            NSFetchRequest* request= [[NSFetchRequest alloc] init];
            //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
            
            // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
            
            [request setEntity:customerEntity];
            //  [request setPredicate:predicate];
            // Specify that the request should return dictionaries.
            [request setResultType:NSDictionaryResultType];
            NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"lpid"];
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

-(void)updateLoanProfile_id:(int)lpID name:(NSString *)name loanAmount:(double)loanAmount payBackTime:(int)payBackTime equalPaymentAmount:(double)equalPaymentAmount yearlyIntRate:(float)yearlyIntRate
{
    NSManagedObject* loanProfile= [self findByID:lpID];
    
    
    [loanProfile setValue:name forKey:@"name"];
   // [loanProfile setValue:[NSNumber numberWithInt:([self getMaxID]+1 )] forKey:@"lpid"];
    [loanProfile setValue:[NSNumber numberWithDouble:yearlyIntRate ]forKey:@"yearlyIntRate"];
    [loanProfile setValue:[NSNumber numberWithDouble:equalPaymentAmount ] forKey:@"equalPaymentAmount"];
    [loanProfile setValue:[NSNumber numberWithInt:payBackTime] forKey:@"payBackTime"];
    
    [loanProfile setValue:[NSNumber numberWithDouble:loanAmount] forKey:@"loanAmount"];
  
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"contact save failed");
    }
    else
    {
        NSLog( @"contact saved");
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

-(void)insertLoanProfile_lp:(LoanProfile *)lp
{
    [self insertLoanProfile_name:lp.name loanAmount:lp.loanAmount payBackTime:lp.paybackTime equalPaymentAmount:lp.equalPaymentAmount yearlyIntRate:lp.interestRate];
}

-(NSMutableArray *)findAllprofiles
{
    NSArray* kindOfRawData=  [self findAll];
    NSMutableArray* result= [[NSMutableArray alloc]init];
    LoanProfile*element;
    for (int i=0; i<[kindOfRawData count]; i++)
    {
        NSManagedObject* current=[kindOfRawData objectAtIndex:i];
        element=[[LoanProfile alloc] initCreateLoanProfile_name:[current valueForKey:@"name"] loanAmount:[[current valueForKey:@"loanAmount"]  doubleValue]  payBackTime: [[current valueForKey:@"payBackTime"] intValue] equalPaymentAmount:[[current valueForKey:@"equalPaymentAmount"] doubleValue]  yearlyIntRate:[[current valueForKey:@"yearlyIntRate"] doubleValue]];
        [element setLPId:[[current valueForKey:@"lpid"] intValue]];
       [result addObject:element ];
        
    }
    
    return result;
}

-(LoanProfile *)findByID_id:(int)lpID
{
    NSManagedObject* current=[self findByID:lpID];
    LoanProfile*result=
    [[LoanProfile alloc] initCreateLoanProfile_name:[current valueForKey:@"name"] loanAmount:[[current valueForKey:@"loanAmount"]  doubleValue]  payBackTime: [[current valueForKey:@"payBackTime"] intValue] equalPaymentAmount:[[current valueForKey:@"equalPaymentAmount"] doubleValue]  yearlyIntRate:[[current valueForKey:@"yearlyIntRate"] doubleValue]];
    
    [result setLPId:lpID];
    return result;
}

-(void)updateLoanProfile_lp:(LoanProfile *)lp
{
    [self  updateLoanProfile_id:lp.lPId name:lp.name loanAmount:lp.loanAmount payBackTime:lp.paybackTime equalPaymentAmount:lp.equalPaymentAmount yearlyIntRate:lp.interestRate];
}

-(void) removeLoanProfile_lp:(LoanProfile *)lp
{
    [self remeove:lp.lPId];
}

@end
