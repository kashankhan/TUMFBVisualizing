//
//  MapViewAnnotation.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 14/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@class Profile;

@interface MapViewAnnotation : NSObject <MKAnnotation>

@property (nonatomic, copy) NSString *title;
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) Profile *profile;

- (id)initWithProfile:(Profile *)profile;

@end