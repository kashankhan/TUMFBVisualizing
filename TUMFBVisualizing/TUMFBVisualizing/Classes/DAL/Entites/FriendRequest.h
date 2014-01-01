//
//  FriendRequest.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 01/01/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile;

@interface FriendRequest : NSManagedObject

@property (nonatomic, retain) NSString * message;
@property (nonatomic, retain) NSDate * time;
@property (nonatomic, retain) NSString * uidFrom;
@property (nonatomic, retain) NSString * uidTo;
@property (nonatomic, retain) Profile *profileInfo;

@end
