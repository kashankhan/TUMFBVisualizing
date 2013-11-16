//
//  PaserHandler.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "PaserHandler.h"
#import "AppDAL.h"

@implementation PaserHandler

- (id)parseFriends:(id)object {

    AppDAL *appDal = [[AppDAL alloc] init];
    
    NSMutableArray *friends = [NSMutableArray array];
    
    for (NSDictionary *friendInfo in [object valueForKey:@"data"]) {
        
        NSString *uid = [friendInfo valueForKey:@"uid"];
        NSString *picUri = [friendInfo valueForKey:@"pic_square"];
        NSString *name = [friendInfo valueForKey:@"name"];

        Profile *friend = [appDal getProfile:uid];
        [friend setUid:uid];
        [friend setPicUri:picUri];
        [friend setName:name];
        
        [friends addObject:friend];
        
        NSDictionary *locationInfo = [friendInfo valueForKey:@"current_location"];
        
        if (locationInfo && ![locationInfo isEqual:[NSNull null]]) {
            
            NSString *locationId = [locationInfo valueForKey:@"id"];
            NSString *city = [locationInfo valueForKey:@"city"];
            NSString *country = [locationInfo valueForKey:@"country"];
            double latitude = [[locationInfo valueForKey:@"latitude"] doubleValue];
            double longitude = [[locationInfo valueForKey:@"longitude"] doubleValue];
            NSString *locationName = [locationInfo valueForKey:@"name"];
            NSString *state = [locationInfo valueForKey:@"state"];
            NSInteger zip = [[locationInfo valueForKey:@"zip"] integerValue];
            
            
            Location *location = [appDal getLocation:locationId];
            [location setLocationId:locationId];
            [location setCity:city];
            [location setCountry:country];
            [location setLatitude:[NSNumber numberWithDouble:latitude]];
            [location setLongitude:[NSNumber numberWithDouble:longitude]];
            [location setName:locationName];
            [location setState:state];
            [location setZip:[NSNumber numberWithInteger:zip]];
             
            
            [friend setCurrentLocationInfo:location];
            [location addProfileInfoObject:friend];
            
            [friends addObject:friend];
        }//if
    }//for
    
    [appDal saveContext];
    return friends;
}

- (id)parseMyProfile:(id)object {

    AppDAL *appDal = [[AppDAL alloc] init];
    Profile *profile = nil;
    if (object) {
        NSString *name = [object valueForKey:@"name"];
        NSString *username = [object valueForKey:@"username"];
        NSString *uid = [object valueForKey:@"id"];
        NSString *picUri = [NSString stringWithFormat:@"http://graph.facebook.com/%@/picture?type=square", username];
        profile = [appDal getProfile:uid];
        [profile setName:name];
        [profile setUid:uid];
        [profile setPicUri:picUri];
        [profile setIsOwnProfile:[NSNumber numberWithBool:YES]];
    }
    
    [appDal saveContext];
    return profile;
}

@end
