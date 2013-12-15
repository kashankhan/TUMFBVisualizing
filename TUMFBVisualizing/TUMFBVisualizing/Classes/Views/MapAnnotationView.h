//
//  MapAnnotationView.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 16/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <MapKit/MapKit.h>

@class Profile;

@interface MapAnnotationView : MKAnnotationView

- (void)setImageWithUri:(NSString *)uri;
- (void)addTagetForDisclose:(id)target action:(SEL)sector;

@property (nonatomic, strong) Profile *profile;

@end
