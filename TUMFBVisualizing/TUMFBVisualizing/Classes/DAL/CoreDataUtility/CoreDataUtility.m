#import "CoreDataUtility.h"


@interface CoreDataUtility (Private)

// Note: This method will return a predicate
- (NSPredicate *)getPredicateWithParams:(NSDictionary *)parms withpredicateOperatorType:(NSArray *)predicateOperatorType;

// return a new autoreleased Unique Id string;
- (NSString *)generateUniqueidString;

@end


/* 
 * Singleton Class for DataModel and CoreData operations 
 */

@implementation CoreDataUtility

@synthesize managedObjectContext;
@synthesize managedObjectModel;
@synthesize persistentStoreCoordinator;



static CoreDataUtility *cdUtilityInstance = nil;


NSString* const kCoreDataBundlePath = @"TUMFBVisualizing.momd";
NSString* const kCoreDataModelName = @"TUMFBVisualizing";
NSString* const kCoreDataStorePath = @"TUMFBVisualizing.xcdatamodeld.sqlite";
NSString* const kDefaultCDStorePath = @"TUMFBVisualizing.xcdatamodeld";


#pragma mark -
#pragma mark Init

+ (CoreDataUtility*)sharedInstance {

    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        cdUtilityInstance = [[CoreDataUtility alloc] init];
    });
    
    return cdUtilityInstance;
}

-(id) init {
    
    self = [super init];
    if (self ) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(managedObjectContextDidSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:nil];
    }
    return self;
}


- (NSManagedObjectContext *)context {
    
    NSThread *currentThread = [NSThread currentThread];
    NSManagedObjectContext *manageContext = nil;
    
    if (currentThread == [NSThread mainThread]) {
        //Main thread just return default context
        manageContext = self.managedObjectContext;
    }//if
    else {
        //Thread safe trickery
        manageContext = [self newContext];
    }//else
    
    return manageContext;
}

- (NSManagedObjectContext *) newContext {
    
    NSThread *currentThread = [NSThread currentThread];
    NSString *contextIdentifierKey = @"contextIdentifierKey";
    NSManagedObjectContext *manageContext  = [[currentThread threadDictionary] objectForKey:contextIdentifierKey];
    if (manageContext == nil)
    {
        manageContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        [manageContext setPersistentStoreCoordinator: [self persistentStoreCoordinator]];
        [[currentThread threadDictionary] setObject:manageContext forKey:contextIdentifierKey];
        
    }//if
    
    return manageContext;

}
#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    
    if (nil == managedObjectContext) {
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            
            managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [managedObjectContext setPersistentStoreCoordinator:coordinator];
        }
    }
    return managedObjectContext;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    
//    if (nil == managedObjectModel) {
//        
//        /*checking for new path of database.
//         - if new path of database exist than return that path.
//         - for versioning the database use the version.plist list
//         - it hold the version identifier path.
//         */
//        NSString *bundlePath = [[NSBundle mainBundle] pathForResource:kCoreDataModelName ofType:@"mom" inDirectory:kCoreDataBundlePath];
//        
//        NSURL *bundlePathUrl = nil;
//        
//        //Note: if new bundle path exist than retrun that managedObjectModel
//        if (nil == bundlePath) {
//            
//            bundlePath = [[NSBundle mainBundle] pathForResource:kCoreDataModelName ofType:@"mom"];
//        }
//        
//        bundlePathUrl = [NSURL fileURLWithPath:bundlePath];
//        managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:bundlePathUrl];
//    }
    
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    
    managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];

    
    return managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    
    if (nil == persistentStoreCoordinator) {
        
        NSString *storePath = [[self applicationDocumentsDirectory] stringByAppendingPathComponent:kCoreDataStorePath];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:storePath]) {
            
            NSString *defaultStorePath = [[NSBundle mainBundle] pathForResource:kDefaultCDStorePath ofType:@"sqlite"];
            
            if (defaultStorePath) {
                
                [fileManager copyItemAtPath:defaultStorePath toPath:storePath error:NULL];
            }
        }
        
        NSURL *storeURL = [NSURL fileURLWithPath:storePath];
        NSError *error = nil;
        persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
        
        NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                                 [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        if (![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
    return persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSString *)applicationDocumentsDirectory {
    
	return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] ;
}

#pragma mark - Delete Object
- (void)deleteObject:(NSManagedObject*)object withContext:(NSManagedObjectContext*)context {

    [context deleteObject:object];

}

#pragma mark -
#pragma mark Save Context

- (BOOL)saveContext {
    
    return [self saveContext:self.managedObjectContext];
}

- (BOOL)saveContext:(NSManagedObjectContext*)context {
    
    NSError *error = nil;
    BOOL saveResult = YES;
    if (context != nil) {
        
        if ([context hasChanges] && ![context save:&error]) {
            
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            saveResult = NO;
        }//if
    }//if
    return saveResult;
}

#pragma mark -Reset All Data.

// Reset all data.
- (void)clearAllDB {
    
    [[self managedObjectContext] lock];
    [[self managedObjectContext] reset];
    NSPersistentStore *store = [[[self persistentStoreCoordinator] persistentStores] lastObject];
    BOOL resetOk = NO;
    
    if (store) {
        NSURL *storeUrl = store.URL;
        NSError *error;
        
        if ([[self persistentStoreCoordinator] removePersistentStore:store error:&error]) {
            persistentStoreCoordinator = nil;
            managedObjectContext = nil;
            
            if (![[NSFileManager defaultManager] removeItemAtPath:storeUrl.path error:&error]) {
                NSLog(@"\nresetDatastore. Error removing file of persistent store: %@",
                      [error localizedDescription]);
                resetOk = NO;
            }//if
            else {
                //now recreate persistent store
                [self persistentStoreCoordinator];
                [[self managedObjectContext] unlock];
            }//else
        }//
        else {
            NSLog(@"\nresetDatastore. Error removing persistent store: %@",
                  [error localizedDescription]);
        }//else
    }//if
}


#pragma mark -
#pragma mark fetchedRecords
- (NSArray *)fetchRecordsForEntity:(NSString *)entityName sortBy:(NSString *)columnName withPredicate:(NSPredicate *)predictae {
    
    return [self fetchRecords:entityName withPredicate:predictae withFetchOffset:0 withFetchLimit:0 sortBy:columnName assending:YES];
}

- (NSArray *)fetchRecordsForEntity:(NSString *)entityName sortBy:(NSString *)columnName withPredicate:(NSPredicate *)predictae  withContext:(NSManagedObjectContext*)context {
    
    context = (context) ? context : [self managedObjectContext];
    
    return [self fetchRecords:entityName withPredicate:predictae withFetchOffset:0 withFetchLimit:0 sortBy:columnName assending:YES withContext:context];
    
}
- (NSArray *)fetchRecords:(NSString *)tableName withPredicate:(NSPredicate *)predicate withFetchOffset:(NSInteger)fetchOffset withFetchLimit:(NSInteger)fetchLimit sortBy:(NSString *)sortColumn assending:(BOOL)isAssending {
    
    
    return [self fetchRecords:tableName withPredicate:predicate withFetchOffset:fetchOffset withFetchLimit:fetchLimit sortBy:sortColumn assending:isAssending withContext:self.managedObjectContext];
}

- (NSArray *)fetchRecords:(NSString *)tableName withPredicate:(NSPredicate *)predicate withFetchOffset:(NSInteger)fetchOffset withFetchLimit:(NSInteger)fetchLimit sortBy:(NSString *)sortColumn assending:(BOOL)isAssending withContext:(NSManagedObjectContext*)context {
    
    NSArray *fetchResults = nil;
    @try {
        
        context = (context) ? context : [self managedObjectContext];
        
        // Define our table/entity to use
        NSEntityDescription *entity = [NSEntityDescription entityForName:tableName inManagedObjectContext:context];
        // Setup the fetch request
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        [request setEntity:entity];
        
        //Set fetch Limit and fetch Offset
        [request setFetchLimit:fetchLimit];
        [request setFetchOffset:fetchOffset];
        
        //Set optionol parameters//
        if(sortColumn)
        {
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:sortColumn ascending:isAssending];
            NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
            if(sortDescriptors) {
                [request setSortDescriptors:sortDescriptors];
            }//if sortDescriptors
        }
        
        if(predicate)
            [request setPredicate:predicate];
        //optional parameters//
        
        
        // Fetch the records and handle an error
        NSError *error;
        
        fetchResults = [NSArray arrayWithArray:[context executeFetchRequest:request error:&error]];
        //NSLog(@"%s fetchResults %@", __func__, fetchResults);
    }
    @catch (NSException *exception) {
        NSLog(@"func :%s exception : %@",__func__,[exception description]);
    }
    @finally {
    }
    return fetchResults;
}


#pragma mark -
#pragma mark Data Filter Methods

// This method will fecth the request
- (NSArray *)executeFetchRequest:(NSString *)entity withAttributeId:(NSString *)attributeID withAttributeName:(NSString *)attribute {
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
	NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:[CoreDataUtility sharedInstance].managedObjectContext];
	[fetchRequest setEntity:entityDescription];
	
    if (attribute && attributeID) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"%K = %@",attribute, attributeID];
        
        [fetchRequest setPredicate:predicate];
    }
    
	
	NSError *error;
	
	NSArray *items = [[CoreDataUtility sharedInstance].managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    return items;
}

//This method will return the predicate depends upon the params
- (NSPredicate *)getPredicateWithParams:(NSDictionary *)parms withpredicateOperatorType:(NSArray *)predicateOperatorType {
    
    NSPredicate *predicate = nil;
    NSMutableArray *subpredicates = [[NSMutableArray alloc] init];
    NSInteger index = 0;
    
    for (NSString *key in [parms allKeys]) {
        
        NSString *value = [parms valueForKey:key];
        
        NSExpression *leftExpression = [NSExpression expressionForKeyPath:key];
        NSExpression *rightExpression = [NSExpression expressionForConstantValue:value];
        
        predicate = [NSComparisonPredicate predicateWithLeftExpression:leftExpression
                                                       rightExpression:rightExpression
                                                              modifier:NSDirectPredicateModifier
                                                                  type: (predicateOperatorType) ?[[predicateOperatorType objectAtIndex:index] intValue] :NSEqualToPredicateOperatorType
                                                               options:NSCaseInsensitivePredicateOption];
        [subpredicates addObject:predicate];
        
        index ++;
        
        predicate = nil;
    }
    predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subpredicates];
    
    return predicate;
}


#pragma mark -managedObjectContextDidSaveNotification
- (void)managedObjectContextDidSaveNotification:(NSNotification*)notification {
    
    NSManagedObjectContext *sender = (NSManagedObjectContext *)[notification object];
    
    if ((sender != managedObjectContext) &&
        (sender.persistentStoreCoordinator == managedObjectContext.persistentStoreCoordinator))
    {
        SEL selector = @selector(mergeChangesFromContextDidSaveNotification:);
        [self.managedObjectContext performSelectorOnMainThread:selector withObject:notification waitUntilDone:YES];
    }
}


@end