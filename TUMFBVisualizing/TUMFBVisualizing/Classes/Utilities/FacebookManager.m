//
//  FacebookManager.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FacebookManager.h"

@implementation FacebookManager

+ (FacebookManager*)sharedManager {
    // 1
    static FacebookManager *_sharedInstance = nil;
    
    // 2
    static dispatch_once_t oncePredicate;
    
    // 3
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[FacebookManager alloc] init];
    });
    
    return _sharedInstance;
}

// Helper method to wrap logic for handling app links.
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken {
    
    // Initialize a new blank session instance...
    FBSession *appLinkSession = [[FBSession alloc] initWithAppID:[NSString stringWithFormat:@"%@",[[[NSBundle mainBundle] infoDictionary] valueForKey:@"FacebookAppID"]]
                                                     permissions:@[@"basic_info",@"user_likes", @"user_friends", @"friends_hometown", @"friends_location"]
                                                 defaultAudience:FBSessionDefaultAudienceNone
                                                 urlSchemeSuffix:nil
                                              tokenCacheStrategy:[FBSessionTokenCachingStrategy nullCacheInstance] ];
    [FBSession setActiveSession:appLinkSession];
    // ... and open it from the App Link's Token.
    [appLinkSession openFromAccessTokenData:appLinkToken
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
                [self handleAppLink:call.accessTokenData];
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

- (void)fecthFreindsWithCompletionHandler:(FacebookManagerRequestHandler)handler {
    
    NSString *query = @"SELECT uid, name, current_location.id, pic_square, current_location.latitude, current_location.longitude, current_location, current_location  FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
    
    [self sendFqlRequest:query withCompletionHandler:handler];
    
//    // Set up the query parameter
//    NSDictionary *queryParam = @{ @"q": query };
//    // Make the API request that uses FQL
//    [FBRequestConnection startWithGraphPath:@"/fql"
//                                 parameters:queryParam
//                                 HTTPMethod:@"GET"
//                          completionHandler:^(FBRequestConnection *connection,
//                                              id result,
//                                              NSError *error) {
//                              if (error) {
//                                  NSLog(@"Error: %@", [error localizedDescription]);
//                              } else {
//                                  NSLog(@"Result: %@", result);
//                              }
//                          }];
}

- (FBLoginView*)getFBLoginViewWithFrame:(CGRect)rect {
    
    return [[FBLoginView alloc] initWithFrame:rect];
}

- (void)fetchUserInboxWithCompletionHandler:(FacebookManagerRequestHandler)handler {
    
      NSString *query = @"SELECT thread_id, message_count, recipients FROM thread WHERE folder_id=0 AND (originator IN (SELECT uid2 FROM friend WHERE uid1 = me()) OR originator=me()) AND updated_time < now() ORDER BY message_count DESC";
    
    
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
//                              if (error) {
//                                  NSLog(@"Error: %@", [error localizedDescription]);
//                              } else {
//                                  NSLog(@"Result: %@", result);
//                              }
                          }];
}
@end