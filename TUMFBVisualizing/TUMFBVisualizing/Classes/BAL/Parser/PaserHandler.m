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

        Friend *friend = [appDal getFriend:uid];
        [friend setUid:uid];
        [friend setPicUri:picUri];
        [friend setName:name];
        
        NSDictionary *locationInfo = [friendInfo valueForKey:@"current_location"];
        
        if (locationInfo) {
            
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
            [location addFrientInfoObject:friend];
            
            [friends addObject:friend];
        }//if

        
    }
    
    [appDal saveContext];
    return friends;
}

@end
