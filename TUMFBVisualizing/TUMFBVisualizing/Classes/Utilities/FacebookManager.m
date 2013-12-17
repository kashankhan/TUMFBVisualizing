//
//  FacebookManager.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FacebookManager.h"

@interface FacebookManager ()

@property (nonatomic, strong) FBSession *session;
@end

@implementation FacebookManager

static FacebookManager *_sharedInstance = nil;

+ (FacebookManager*)sharedManager {
    
    static dispatch_once_t oncePredicate;

    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FacebookManager alloc] init];
        [_sharedInstance refreshFacebookSession];
    });
    
    return _sharedInstance;
}

- (BOOL)isSessionActive {

    return [[FBSession activeSession] isOpen];
}

- (void)closeActiveSession {

    // if the app is going away, we close the session object
    [FBSession.activeSession close];
}

- (void)logout {
    
    [self closeActiveSession];
    [[FBSession activeSession] closeAndClearTokenInformation];
}

- (void)perfromLogin {
    
    self.session = [self getFacebookNewSession];
    
    [self.session openWithCompletionHandler:^(FBSession *session,
                                                     FBSessionState status,
                                                     NSError *error) {
    }];

}

- (void)refreshFacebookSession {

    if (self.session.state == FBSessionStateCreatedTokenLoaded) {
        // even though we had a cached token, we need to login to make the session usable
        [self.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // we recurse here, in order to update buttons and labels
            [[NSNotificationCenter defaultCenter] postNotificationName:UIFacebookLUserSessionNotification object:[NSNumber numberWithBool:(error) ? NO : YES]];
        }];
    }
}

- (FBSession *)getFacebookNewSession {

   return [[FBSession alloc] initWithAppID:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] valueForKey:@"FacebookAppID"]]
                         permissions:@[@"basic_info",@"user_likes", @"user_friends", @"friends_hometown", @"friends_location", @"read_mailbox", @"read_requests"]
                     defaultAudience:FBSessionDefaultAudienceNone
                     urlSchemeSuffix:nil
                  tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance]];
}
// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    
    // Initialize a new blank session instance...
    self.session = [self getFacebookNewSession];

    [FBSession setActiveSession:self.session];
    // ... and open it from the App Link's Token.
    [self.session openFromAccessTokenData:appLinkToken
                          completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
                              // Forward any errors to the FBLoginView delegate.
                              if (error) {
                                  NSString *alertMessage, *alertTitle;
                                  
                                  // Facebook SDK * error handling *
                                  // Error handling is an important part of providing a good user experience.
                                  // Since this sample uses the FBLoginView, this delegate will respond to
                                  // login failures, or other failures that have closed the session (such
                                  // as a token becoming invalid). Please see the [- postOpenGraphAction:]
                                  // and [- requestPermissionAndPost] on `SCViewController` for further
                                  // error handling on other operations.
                                  
                                  if (error.fberrorShouldNotifyUser) {
                                      // If the SDK has a message for the user, surface it. This conveniently
                                      // handles cases like password change or iOS6 app slider state.
                                      alertTitle = @"Something Went Wrong";
                                      alertMessage = error.fberrorUserMessage;
                                  } else if (error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
                                      // It is important to handle session closures as mentioned. You can inspect
                                      // the error for more context but this sample generically notifies the user.
                                      alertTitle = @"Session Error";
                                      alertMessage = @"Your current session is no longer valid. Please log in again.";
                                  } else if (error.fberrorCategory == FBErrorCategoryUserCancelled) {
                                      // The user has cancelled a login. You can inspect the error
                                      // for more context. For this sample, we will simply ignore it.
                                      NSLog(@"user cancelled login");
                                  } else {
                                      // For simplicity, this sample treats other errors blindly, but you should
                                      // refer to https://developers.facebook.com/docs/technical-guides/iossdk/errors/ for more information.
                                      alertTitle  = @"Unknown Error";
                                      alertMessage = @"Error. Please try again later.";
                                      NSLog(@"Unexpected error:%@", error);
                                  }
                                  
                                  if (alertMessage) {
                                      [[[UIAlertView alloc] initWithTitle:alertTitle
                                                                  message:alertMessage
                                                                 delegate:nil
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:nil] show];
                                  }
                              }
                              
                              
                              [[NSNotificationCenter defaultCenter] postNotificationName:UIFacebookLUserSessionNotification object:[NSNumber numberWithBool:(error) ? NO : YES]];
                          }];
}

- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication {

    // Facebook SDK * login flow *
    // Attempt to handle URLs to complete any auth (e.g., SSO) flow.
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication fallbackHandler:^(FBAppCall *call) {
        // Facebook SDK * App Linking *
        // For simplicity, this sample will ignore the link if the session is already
        // open but a more advanced app could support features like user switching.
        if (call.accessTokenData) {
            if ([FBSession activeSession].isOpen) {
                NSLog(@"INFO: Ignoring app link because current session is open.");
            }//if
            else {
                [_sharedInstance handleAppLink:call.accessTokenData];
            }//else
        }//if
    }];
}



//- (void)fecthFreinds {
//    
//    [FBRequestConnection startWithGraphPath:@"me/friends" parameters:[ NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name, hometown,location",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        
//        if(!error){
//            NSLog(@"results = %@", [result valueForKey:@"data"]);
//            //[self fecthFreinds:offset + [limit integerValue]];
//            
//        }
//    }];
//}

- (void)fetchMyProfile:(FacebookManagerRequestHandler)handler {
    
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if (handler) {
            handler(connection, result, error);
        }//if
    }];
}

- (void)fetchFreindsLocationWithCompletionHandler:(FacebookManagerRequestHandler)handler {
    
    NSString *query = @"SELECT uid, name, current_location.id, pic_square, current_location.latitude, current_location.longitude, current_location, current_location  FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
    
    [self sendFqlRequest:query withCompletionHandler:handler];

}

- (void)fetchUserInboxWithCompletionHandler:(FacebookManagerRequestHandler)handler {
    
      NSString *query = @"SELECT thread_id, message_count, recipients FROM thread WHERE folder_id=0 AND (originator IN (SELECT uid2 FROM friend WHERE uid1 = me()) OR originator=me()) AND updated_time < now() ORDER BY message_count DESC";
//
//          NSString *query = @"SELECT thread_id, message_count, recipients FROM thread WHERE folder_id=0 AND updated_time < now() ORDER BY message_count DESC";
    
    [self sendFqlRequest:query withCompletionHandler:handler];
    
}

- (void)fetchUserUnRespondedFriendRequests:(FacebookManagerRequestHandler)handler  {
   
    NSString *query =  @"SELECT time, message, uid_from, uid_to FROM friend_request WHERE uid_to = me()";
    [self sendFqlRequest:query withCompletionHandler:handler];
}
- (void)sendFqlRequest:(NSString *)query withCompletionHandler:(FacebookManagerRequestHandler)handler {
    

    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (handler) {
                                  handler(connection,
                                   result,
                                          error);
                              }//if
                          }];
}
@end
