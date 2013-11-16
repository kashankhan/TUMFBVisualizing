//
//  Location.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 16/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Profile;

@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) NSSet *profileInfo;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addProfileInfoObject:(Profile *)value;
- (void)removeProfileInfoObject:(Profile *)value;
- (void)addProfileInfo:(NSSet *)values;
- (void)removeProfileInfo:(NSSet *)values;

@end
