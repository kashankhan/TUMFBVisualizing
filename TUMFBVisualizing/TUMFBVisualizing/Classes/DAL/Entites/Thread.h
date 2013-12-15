//
//  Thread.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile;

@interface Thread : NSManagedObject

@property (nonatomic, retain) NSString * messageCount;
@property (nonatomic, retain) NSString * recipients;
@property (nonatomic, retain) NSString * threadId;
@property (nonatomic, retain) NSSet *profilesInfo;
@end

@interface Thread (CoreDataGeneratedAccessors)

- (void)addProfilesInfoObject:(Profile *)value;
- (void)removeProfilesInfoObject:(Profile *)value;
- (void)addProfilesInfo:(NSSet *)values;
- (void)removeProfilesInfo:(NSSet *)values;

@end
