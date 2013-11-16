//
//  AppDAL.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Profile.h"
#import "Location.h"

@class CoreDataUtility;

@interface AppDAL : NSObject

@property (nonatomic, strong) CoreDataUtility *coreDataUtility;

- (NSArray *)getAllFriends;
- (Profile *)getProfile:(NSString *)uid;
- (Location *)getLocation:(NSString *)locationId;
- (void)saveContext;

@end
