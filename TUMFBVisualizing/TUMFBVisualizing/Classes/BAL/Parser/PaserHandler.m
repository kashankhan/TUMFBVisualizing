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
        [friend setProfileType:[NSNumber numberWithInt:ProfileTypeFriend]];
        
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
            

        }//if
        
        [friends addObject:friend];
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
        [profile setProfileType:[NSNumber numberWithInt:ProfileTypeMine]];
    }
    
    [appDal saveContext];
    return profile;
}

- (id)parseInboxInfo:(id)object {

    NSMutableArray *threads = [NSMutableArray array];
    Thread *thread = nil;
    AppDAL *appDal = [[AppDAL alloc] init];
    
    for (NSDictionary *threadInfo in [object valueForKey:@"data"]) {
        NSString *msgCount = [[threadInfo valueForKey:@"message_count"] stringValue];
        NSString *threadId = [[threadInfo valueForKey:@"thread_id"] stringValue];
        NSArray *recipients = [threadInfo valueForKey:@"recipients"];
        
        thread = [appDal getThread:threadId];
        
        [thread setThreadId:threadId];
        [thread setMessageCount:msgCount];
        [thread setRecipients:[recipients description]];
        
        for (NSString *recipientId in recipients) {
            Profile *profile = [appDal getProfile:recipientId];
            [thread addProfilesInfoObject:profile];
            [profile addThreadsInfoObject:thread];
        }

        [threads addObject:thread];
    }
    
    [appDal saveContext];
    return threads;
}

- (id)parseFriendshipRequestsInfo:(id)object {

    AppDAL *appDal = [[AppDAL alloc] init];
    NSMutableArray *friendRequests = [NSMutableArray array];
    for (NSDictionary *requestInfo in [object valueForKey:@"data"]) {

        NSString *message = ( [[requestInfo valueForKey:@"message"] isKindOfClass:[NSString class]]) ?[requestInfo valueForKey:@"message"] : @"";
        NSDate *time = [NSDate dateWithTimeIntervalSince1970:[[requestInfo valueForKey:@"time"] doubleValue] / 1000];
        NSString *uidFrom = [requestInfo valueForKey:@"uid_from"];
        NSString *uidTo = [requestInfo valueForKey:@"uid_to"];

        FriendRequest *friendRequest = [appDal getFriendRequest:uidFrom];
        
        [friendRequest setUidFrom:uidFrom];
        [friendRequest setUidTo:uidTo];
        [friendRequest setTime:time];
        [friendRequest setMessage:message];
        
        [friendRequests addObject:friendRequest];
        
    }//for
    
    [appDal saveContext];
    return friendRequests;

}

- (id)parseFriendshipRequestFriendInfo:(id)object {
    AppDAL *appDal = [[AppDAL alloc] init];
    

    FriendRequest *friendRequest = nil;
    for (NSDictionary *requestInfo in [object valueForKey:@"data"]) {
        NSString *name = [requestInfo valueForKey:@"name"];
        NSString *uid = [requestInfo valueForKey:@"uid"];
        NSString *picUri = [requestInfo valueForKey:@"pic_square"];
     
        Profile *profile = [appDal getProfile:uid];
        [profile setUid:uid];
        [profile setPicUri:picUri];
        [profile setName:name];
        [profile setProfileType:[NSNumber numberWithInt:ProfileTypeFriendshipRequestFriend]];
        
        friendRequest = [appDal getFriendRequest:uid];
        
        [friendRequest setProfileInfo:profile];
        [profile setFriendRequestInfo:friendRequest];

        
    }//for
    
    [appDal saveContext];
    
    return friendRequest;

}
@end
