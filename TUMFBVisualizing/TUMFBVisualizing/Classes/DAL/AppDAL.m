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


- (void)saveContext {
    
    [[CoreDataUtility sharedInstance] saveContext];
}
- (NSArray*)getAllFriends {
    
    return [self.coreDataUtility fetchRecordsForEntity:@"Friend" sortBy:nil withPredicate:nil];
    
}

- (Friend *)getFriend:(NSString *)uid {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    return (Friend*)[self getObjectWithEntity:@"Friend" withPredicate:predicate createNewIfNotFound:YES];
}

- (Location *)getLocation:(NSString *)locationId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationId = %@", locationId];
    return (Location*)[self getObjectWithEntity:@"Location" withPredicate:predicate createNewIfNotFound:YES];
}

- (NSManagedObject*)getObjectWithEntity:(NSString*)entity withPredicate:(NSPredicate*)predicate createNewIfNotFound:(BOOL)create {
    
    NSManagedObject *manageObject = nil;
    NSArray *list = [_coreDataUtility fetchRecordsForEntity:entity sortBy:nil withPredicate:predicate];
    // check if the user info is no exist create the new one.
    if (![list count]) {
        if (create) {
            manageObject = [NSEntityDescription insertNewObjectForEntityForName:entity inManagedObjectContext:[_coreDataUtility managedObjectContext]];
        }//if
    }//if
    else {
        manageObject = [list objectAtIndex:0];
    }//else
    
    return manageObject;
    
}
@end
