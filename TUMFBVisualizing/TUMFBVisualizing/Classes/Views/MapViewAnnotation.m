//
//  MapViewAnnotation.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 14/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "MapViewAnnotation.h"
#import "Profile.h"
#import "Location.h"

@implementation MapViewAnnotation

- (id)initWithProfile:(Profile *)profile {
    
    self = [super init];
	
    if (self) {
        CLLocationCoordinate2D location;
        if (profile.currentLocationInfo) {
            location.latitude = [profile.currentLocationInfo.latitude doubleValue];
            location.longitude = [profile.currentLocationInfo.longitude doubleValue];
            self.title = profile.name;
            self.coordinate = location;
            self.profile = profile;
            
        }
    }
	return self;
}

@end