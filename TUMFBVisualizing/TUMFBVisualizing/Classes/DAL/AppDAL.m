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
    
    return [self.coreDataUtility fetchRecordsForEntity:NSStringFromClass([Profile class]) sortBy:nil withPredicate:[NSPredicate predicateWithFormat:@"isOwnProfile = NO"]];
    
}

- (Profile *)getProfile:(NSString *)uid{

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"uid = %@", uid];
    return (Profile*)[self getObjectWithEntity:NSStringFromClass([Profile class]) withPredicate:predicate createNewIfNotFound:YES];
}

- (Location *)getLocation:(NSString *)locationId {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"locationId = %@", locationId];
    return (Location*)[self getObjectWithEntity:NSStringFromClass([Location class])  withPredicate:predicate createNewIfNotFound:YES];
}

- (Thread *)getThread:(NSString *)threadId {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"threadId = %@", threadId];
    return (Thread*)[self getObjectWithEntity:NSStringFromClass([Thread class])  withPredicate:predicate createNewIfNotFound:YES];
}


- (NSArray *)getAllThreadsBetweenProfiles:(NSString *)profileId1 person2:(NSString *)profileId2 {
  
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recipients CONTAINS[c] %@ AND recipients CONTAINS[c] %@", profileId1, profileId2];
    return [self.coreDataUtility fetchRecordsForEntity:NSStringFromClass([Thread class]) sortBy:nil withPredicate:predicate];

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
