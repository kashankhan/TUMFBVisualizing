//
//  Profile.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Location;

@interface Profile : NSManagedObject

@property (nonatomic, retain) NSNumber * isOwnProfile;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * picUri;
@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) Location *currentLocationInfo;
@property (nonatomic, retain) NSSet *threadsInfo;
@end

@interface Profile (CoreDataGeneratedAccessors)

- (void)addThreadsInfoObject:(NSManagedObject *)value;
- (void)removeThreadsInfoObject:(NSManagedObject *)value;
- (void)addThreadsInfo:(NSSet *)values;
- (void)removeThreadsInfo:(NSSet *)values;

@end
