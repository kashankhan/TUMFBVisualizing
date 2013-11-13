//
//  Location.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Location : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * locationId;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * zip;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSSet *frientInfo;
@end

@interface Location (CoreDataGeneratedAccessors)

- (void)addFrientInfoObject:(NSManagedObject *)value;
- (void)removeFrientInfoObject:(NSManagedObject *)value;
- (void)addFrientInfo:(NSSet *)values;
- (void)removeFrientInfo:(NSSet *)values;

@end
