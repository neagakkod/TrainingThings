//
//  CustomerData.m
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "CustomerData.h"
#import "AddressData.h"

@interface CustomerData(private)
-(NSManagedObject*)findByID:(int)lpID;
-(NSArray*)findAll;//array of NSManagedObjects
-(void) remeove:(int)lpID;
-(int) maxID;
-(void)updateCustomer_id:(int)cID firstName:(NSString*)firstName lastName:(NSString*)lastName  loaner:(BOOL)loaner phone:(NSString*)phone profileID:(int)profileID ;//addressID:(int)addressID;

-(void)insertCustomer_firstName:(NSString*)firstName lastName:(NSString*)lastName  loaner:(BOOL)loaner phone:(NSString*)phone profileID:(int)profileID;// city:(NSString*)city country:(NSString*)country region:(NSString*)region streetAddress:(NSString*)streetAddress zipCode:(NSString*)zipCode ;
@end
@implementation CustomerData



@synthesize currentCustomer;
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

static CustomerData* instance=nil;

+(CustomerData*)getInstance
{
    if(instance==nil)
    {
        instance=[[CustomerData alloc] init];
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
    
    NSEntityDescription* CustomerEntity= [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(cid= %i)",lpID ];
    // NSSortDescriptor * sorting= [NSSortDescriptor sort] used for sorting
    
    [request setEntity:CustomerEntity];
    [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return [objects objectAtIndex:0];
}


-(int)maxID
{
    if ([[self findAll] count]>0)
    {
        NSEntityDescription* customerEntity= [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:_managedObjectContext];
        NSFetchRequest* request= [[NSFetchRequest alloc] init];
        //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
        
        // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
        
        [request setEntity:customerEntity];
        //  [request setPredicate:predicate];
        // Specify that the request should return dictionaries.
        [request setResultType:NSDictionaryResultType];
        NSExpression *keyPathExpression = [NSExpression expressionForKeyPath:@"cid"];
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

-(NSArray*)findAll//array of NSManagedObjects
{
    
    NSEntityDescription* CustomerEntity= [NSEntityDescription entityForName:@"Customer" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
    
    // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
    
    [request setEntity:CustomerEntity];
    //  [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    NSLog(@"%@",objects);
    return objects;
    
}

-(void)insertCustomer_firstName:(NSString*)firstName lastName:(NSString*)lastName  loaner:(BOOL)loaner phone:(NSString*)phone profileID:(int)profileID//city:(NSString*)city country:(NSString*)country region:(NSString*)region streetAddress:(NSString*)streetAddress zipCode:(NSString*)zipCode ;

{
     int maxID=[self maxID];
    NSManagedObject* newCustomer= [NSEntityDescription insertNewObjectForEntityForName:@"Customer" inManagedObjectContext:_managedObjectContext];
    
   
    [newCustomer setValue:firstName forKey:@"firstName"];
    [newCustomer setValue:[NSNumber numberWithInt:(maxID+1)] forKey:@"cid"];
    [newCustomer setValue:lastName forKey:@"lastName"];
    [newCustomer setValue:[NSNumber numberWithBool:loaner] forKey:@"loaner"];
    
    [newCustomer setValue:phone forKey:@"phone"];
    
    [newCustomer setValue:[NSNumber numberWithInt:profileID] forKey:@"profileID"];
    //
    //create address
    
    //newCustomer valueForKey:@"pk"
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"customer save failed");
    }
    else
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"Congrats!" message:[NSString stringWithFormat:@"Woah.You Inserted With Success!"] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"customer saved");
    }

    
}


-(void)updateCustomer_id:(int)cID firstName:(NSString*)firstName lastName:(NSString*)lastName  loaner:(BOOL)loaner phone:(NSString*)phone profileID:(int)profileID //addressID:(int)addressID;

{
    NSManagedObject* customer= [self findByID:cID];
    
    
    [customer setValue:firstName forKey:@"firstName"];
    
    [customer setValue:lastName forKey:@"lastName"];
    [customer setValue:[NSNumber numberWithBool:loaner] forKey:@"loaner"];
    
    [customer setValue:phone forKey:@"phone"];
    
    [customer setValue:[NSNumber numberWithInt:profileID] forKey:@"profileID"];
    // update address too
    //AddressData*add=[AddressData getInstance];
    //[add updateAddress_ad:  [add findByID_id:addressID]];
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"customer save failed");
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

-(void)insertCustomer_c:(NSDictionary *)c
{
    [self insertCustomer_firstName:[c objectForKey:@"firstName"] lastName:[c objectForKey:@"lastName"] loaner:(BOOL)[c objectForKey:@"loaner"]  phone:[c objectForKey:@"phone"] profileID:(int)[c objectForKey:@"profileID"]];// city:[[c objectForKey:@"address"] objectForKey:@"city"] country:[[c objectForKey:@"address"] objectForKey:@"ccountry"]  region:[[c objectForKey:@"address"] objectForKey:@"region"]  streetAddress:[[c objectForKey:@"address"] objectForKey:@"streetAddress"]  zipCode:[[c objectForKey:@"address"] objectForKey:@"zipCode"] ];
}

-(NSMutableArray*)findCustomers
{
    NSArray* kindOfRawData=  [self findAll];
    NSMutableArray* result= [[NSMutableArray alloc]init];
      for (int i=0; i<[kindOfRawData count]; i++)
    {
        NSManagedObject* current=[kindOfRawData objectAtIndex:i];
        NSMutableDictionary*element= [[NSMutableDictionary alloc]init];

       
        [element setValue:[current valueForKey:@"firstName"] forKey:@"firstName"];
        [element setValue:[current valueForKey:@"lastName"] forKey:@"lastName"];
        [element setValue:[current valueForKey:@"cid"] forKey:@"cid"];
        [element setValue:[current valueForKey:@"loaner"] forKey:@"loaner"];
        [element setValue:[current valueForKey:@"phone"] forKey:@"phone"];
        [element setValue:[current valueForKey:@"profileID"] forKey:@"profileID"];
        
       // [element setValue:[current valueForKey:@"address"] forKey:@"address"];
      //address
         NSLog(@"indiction: %@",element);
        [result addObject:element ];
        
    }
    NSLog(@"indiction: %@",result);

    return result;
}

-(NSDictionary*)findByID_id:(int)lpID
{
    NSManagedObject* current=[self findByID:lpID];
    
     NSDictionary*element= [[NSDictionary alloc]init];

    [element setValue:[current valueForKey:@"firstName"] forKey:@"firstName"];
    [element setValue:[current valueForKey:@"lastName"] forKey:@"lastName"];
    [element setValue:[current valueForKey:@"pk"] forKey:@"cid"];
    [element setValue:[current valueForKey:@"loaner"] forKey:@"loaner"];
    [element setValue:[current valueForKey:@"phone"] forKey:@"phone"];
    [element setValue:[current valueForKey:@"profileID"] forKey:@"profileID"];

    return element;
}

- (void)updateCustomer_c:(NSDictionary*)c;
{
    [self updateCustomer_id:[[c objectForKey:@"cid"] intValue] firstName:[c objectForKey:@"firstName"]  lastName:[c objectForKey:@"lastName"] loaner:(BOOL)[c objectForKey:@"loaner"]  phone:[c objectForKey:@"phone"]  profileID:(int)[c objectForKey:@"profileID"]]; //] addressID:(int)[[c objectForKey:@"address"] objectForKey:@"aid"]];
  }

-(void) removeCustomer_c:(NSDictionary*)cid
{
    [self remeove:(int)[cid objectForKey:@"cid"]];
}
-(int)maxcID
{
    return [self maxID];
}

@end
