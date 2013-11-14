//
//  MapViewAnnotation.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 14/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "MapViewAnnotation.h"

@implementation MapViewAnnotation



- (id)initWithTitle:(NSString *)ttl andCoordinate:(CLLocationCoordinate2D)coordinat2D {

	self = [super init];
	
    if (self) {
        self.title = ttl;
        self.coordinate = coordinat2D;
    }
	return self;
}

@end