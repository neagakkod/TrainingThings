//
//  AddressData.m
//  SaveCal
//
//  Created by user on 10/25/12.
//  Copyright (c) 2012 user. All rights reserved.
//

#import "AddressData.h"


@interface AddressData(private)
-(NSManagedObject*)findByID:(int)adID;
-(NSManagedObject*)findByCustomerId:(int)cID;
-(NSArray*)findAll;//array of NSManagedObjects
-(void) remeove:(int)adID;

-(void)updateAddress_id:(int)adID city:(NSString*)city country:(NSString*)country  customerID:(int)customerID region:(NSString*)region streetAddress:(NSString*)streetAddress zipcode:(NSString*)zipcode;

-(void)insertAddress_city:(NSString*)city country:(NSString*)country  customerID:(int)customerID region:(NSString*)region streetAddress:(NSString*)streetAddress zipcode:(NSString*)zipcode ;
@end

@implementation AddressData

@synthesize currentAddress;
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

static AddressData* instance=nil;

+(AddressData*)getInstance
{
    if(instance==nil)
    {
        instance=[[AddressData alloc] init];
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

-(NSManagedObject *)findByCustomerId:(int)cID
{
    NSEntityDescription* CustomerEntity= [NSEntityDescription entityForName:@"Address" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(customerID= %i)",cID ];
    // NSSortDescriptor * sorting= [NSSortDescriptor sort] used for sorting
    
    [request setEntity:CustomerEntity];
    [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return [objects objectAtIndex:0];

    
}
-(NSManagedObject*)findByID:(int)lpID
{
    
    NSEntityDescription* CustomerEntity= [NSEntityDescription entityForName:@"Address" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(aid= %i)",lpID ];
    // NSSortDescriptor * sorting= [NSSortDescriptor sort] used for sorting
    
    [request setEntity:CustomerEntity];
    [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return [objects objectAtIndex:0];
}


-(NSArray*)findAll//array of NSManagedObjects
{
    
    NSEntityDescription* CustomerEntity= [NSEntityDescription entityForName:@"Address" inManagedObjectContext:_managedObjectContext];
    NSFetchRequest* request= [[NSFetchRequest alloc] init];
    //NSPredicate* predicate=[ NSPredicate predicateWithFormat:@"(lpid= %i)",lpID ];
    
    // + (id)sortDescriptorWithKey:(NSString *)key ascending:(BOOL)ascending
    
    [request setEntity:CustomerEntity];
    //  [request setPredicate:predicate];
    
    NSError * error ;
    NSArray * objects=[ _managedObjectContext executeFetchRequest:request error:&error];
    
    return objects;
    
}

-(void)insertAddress_city:(NSString*)city country:(NSString*)country  customerID:(int)customerID region:(NSString*)region streetAddress:(NSString*)streetAddress zipcode:(NSString*)zipcode

{
    
    NSManagedObject* newAddress= [NSEntityDescription insertNewObjectForEntityForName:@"Address" inManagedObjectContext:_managedObjectContext];
   
    
    [newAddress setValue:city forKey:@"city"];
    
    [newAddress setValue:country forKey:@"country"];
    [newAddress setValue:[ NSNumber numberWithInt:customerID] forKey:@"customerID"];
    
    [newAddress setValue:region forKey:@"region"];
    [newAddress setValue:zipcode forKey:@"zipcode"];
    [newAddress setValue:streetAddress forKey:@"streetAddress"];
    //
    //create address
    
    //newCustomer valueForKey:@"pk"
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"address save failed");
    }
    else
    {
        NSLog( @"address saved");
    }
    
    
}


-(void)updateAddress_id:(int)adID city:(NSString*)city country:(NSString*)country  customerID:(int)customerID region:(NSString*)region streetAddress:(NSString*)streetAddress zipcode:(NSString*)zipcode

{
    NSManagedObject* address= [self findByCustomerId:customerID];//[self findByID:adID];
    
    
    
    [address setValue:city forKey:@"city"];
    
    [address setValue:country forKey:@"country"];
    [address setValue:[ NSNumber numberWithInt:customerID] forKey:@"customerID"];
    
    [address setValue:region forKey:@"region"];
    [address setValue:zipcode forKey:@"zipcode"];
    [address setValue:streetAddress forKey:@"streetAddress"];
    // update address too
    NSError * error;
    if (![_managedObjectContext save:&error])
    {
        UIAlertView* alert= [[UIAlertView alloc] initWithTitle:@"save failed" message:[NSString stringWithFormat:@"save to core data failed \n %@",[error localizedDescription]] delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
        NSLog( @"address save failed");
    }
    else
    {
        NSLog( @"address saved");
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

- (void)insertAddress_ad:(NSDictionary*)c
{
    [self insertAddress_city:[c objectForKey:@"city"] country:[c objectForKey:@"country"]  customerID:[[c objectForKey:@"customerID"] intValue] region:[c objectForKey:@"region"] streetAddress:[c objectForKey:@"streetAddress"] zipcode:[c objectForKey:@"zipcode"]];
    
}

-(NSMutableArray*)findAllAddresss
{
    NSArray* kindOfRawData=  [self findAll];
    NSMutableArray* result= [[NSMutableArray alloc]init];
    NSDictionary*element= [[NSDictionary alloc]init];
    for (int i=0; i<[kindOfRawData count]; i++)
    {
        NSManagedObject* current=[kindOfRawData objectAtIndex:i];
        [element setValue:[current valueForKey:@"city"] forKey:@"city"];
        [element setValue:[current valueForKey:@"country"] forKey:@"country"];
        [element setValue:[current valueForKey:@"customerID"] forKey:@"customerID"];
        [element setValue:[current valueForKey:@"region"] forKey:@"region"];
        [element setValue:[current valueForKey:@"streetAddress"] forKey:@"streetAddress"];
        [element setValue:[current valueForKey:@"zipcode"] forKey:@"zipcode"];
        [element setValue:[current valueForKey:@"pk"] forKey:@"id"];
        
        //address
        [result addObject:element ];
        
    }
    
    return result;
}

-(NSDictionary *)findBy_customerid:(int)customerid
{
   
    
    
    NSManagedObject* current=[  self findByCustomerId:customerid];
    
    NSArray *keys = [[[current entity] attributesByName] allKeys];
    NSDictionary *element = [current dictionaryWithValuesForKeys:keys];
 
    NSLog(@"element:%@",element);
    return element;

}

-(NSDictionary*)findByID_id:(int)lpID
{
    NSManagedObject* current=[self findByID:lpID];
    NSDictionary*element= [[NSDictionary alloc]init];
    
    [element setValue:[current valueForKey:@"city"] forKey:@"city"];
    [element setValue:[current valueForKey:@"country"] forKey:@"country"];
    [element setValue:[current valueForKey:@"customerID"] forKey:@"customerID"];
    [element setValue:[current valueForKey:@"region"] forKey:@"region"];
    [element setValue:[current valueForKey:@"streetAddress"] forKey:@"streetAddress"];
    [element setValue:[current valueForKey:@"zipcode"] forKey:@"zipcode"];
    return element;
}


- (void)updateAddress_ad:(NSDictionary*)c
{
    [self updateAddress_id:[[c objectForKey:@"id"] intValue] city:[c objectForKey:@"city"] country:[c objectForKey:@"country"] customerID:[[c objectForKey:@"customerID"] intValue] region:[c objectForKey:@"region"] streetAddress:[c objectForKey:@"streetAddress"] zipcode:[c objectForKey:@"zipcode"]];
}

-(void)removeAddress_ad:(NSDictionary*)cid
{
    [self remeove:(int)[cid objectForKey:@"cid"]];
}

@end
