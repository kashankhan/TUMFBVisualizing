//
//  Profile.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 18/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FriendRequest, Location, Thread;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * picUri;
@property (nonatomic, retain) NSNumber * profileType;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) Location *currentLocationInfo;
@property (nonatomic, retain) NSSet *threadsInfo;
@property (nonatomic, retain) FriendRequest *friendRequestInfo;
@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addThreadsInfoObject:(Thread *)value;
- (void)removeThreadsInfoObject:(Thread *)value;
- (void)addThreadsInfo:(NSSet *)values;
- (void)removeThreadsInfo:(NSSet *)values;

@end
