//
//  CoreDataUtility.h
//  IDGARD
//
//  Created by Kashan Khan on 8/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataUtility : NSObject {
    
    NSManagedObjectContext *managedObjectContext;
    NSManagedObjectModel *managedObjectModel;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

//Shared Instance of FLCoreDataUtility and ManagedObjectContext
+ (CoreDataUtility *)sharedInstance;
- (NSManagedObjectContext *) context;
- (NSManagedObjectContext *) newContext;

//Save Context
- (BOOL)saveContext;
- (BOOL)saveContext:(NSManagedObjectContext*)context;
//Delete Object From Context
- (void)deleteObject:(NSManagedObject*)object withContext:(NSManagedObjectContext*)context;
// Reset all data.
- (void)clearAllDB;

//Perform Fetch
- (NSArray *)fetchRecordsForEntity:(NSString *)entityName sortBy:(NSString *)columnName withPredicate:(NSPredicate *)predictae;
- (NSArray *)fetchRecordsForEntity:(NSString *)entityName sortBy:(NSString *)columnName withPredicate:(NSPredicate *)predictae  withContext:(NSManagedObjectContext*)context;
- (NSArray *)fetchRecords:(NSString *)tableName withPredicate:(NSPredicate *)predicate withFetchOffset:(NSInteger)fetchOffset withFetchLimit:(NSInteger)fetchLimit sortBy:(NSString *)sortColumn assending:(BOOL)isAssending;

- (NSArray *)fetchRecords:(NSString *)tableName withPredicate:(NSPredicate *)predicate withFetchOffset:(NSInteger)fetchOffset withFetchLimit:(NSInteger)fetchLimit sortBy:(NSString *)sortColumn assending:(BOOL)isAssending withContext:(NSManagedObjectContext*)context;


@end
