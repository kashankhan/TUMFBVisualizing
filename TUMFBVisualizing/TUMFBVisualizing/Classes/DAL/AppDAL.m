//
//  AppDAL.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "AppDAL.h"
#import "CoreDataUtility.h"

@implementation AppDAL

- (id)init {

    self = [super init];
    if (self) {
        [self setCoreDataUtility:[CoreDataUtility sharedInstance]];
    }
    
    return self;
}

- (void)saveContext {
    
    [[CoreDataUtility sharedInstance] saveContext];
}
- (NSArray*)getAllFriends {
    
    return [self.coreDataUtility fetchRecordsForEntity:@"Friend" sortBy:nil withPredicate:nil];
    
}

- (Friend *)getFriend:(NSString *)uid {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    return (Friend*)[self getObjectWithEntity:NSStringFromClass([Friend class]) withPredicate:predicate createNewIfNotFound:YES];
}

- (Location *)getLocation:(NSString *)locationId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationId = %@", locationId];
    return (Location*)[self getObjectWithEntity:NSStringFromClass([Location class])  withPredicate:predicate createNewIfNotFound:YES];
}

- (NSManagedObject*)getObjectWithEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate createNewIfNotFound:(BOOL)create {
    
    NSManagedObject *manageObject = nil;
    NSArray *list = [self.coreDataUtility fetchRecordsForEntity:entity sortBy:nil withPredicate:predicate];
    // check if the user info is no exist create the new one.
    if (![list count]) {
        if (create) {
            manageObject = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:[self.coreDataUtility context]];
        }//if
    }//if
    else {
        manageObject = [list objectAtIndex:0];
    }//else
    
    return manageObject;
    
}
@end
