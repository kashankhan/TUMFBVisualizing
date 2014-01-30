//
//  FacebookManager.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

typedef void (^FacebookManagerRequestHandler)(FBRequestConnection *connection,
                                 id result,
                                 NSError *error);

@interface FacebookManager : NSObject

+ (FacebookManager*)sharedManager;
- (BOOL)isSessionActive;
- (void)closeActiveSession;
- (void)perfromLogin;
- (void)logout;
- (void)activateSession;
- (void)handleAppLink:(FBAccessTokenData *)appLinkToken;
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
- (void)fetchMyProfile:(FacebookManagerRequestHandler)handler;
- (void)fetchFreindsLocationWithCompletionHandler:(FacebookManagerRequestHandler)handler;
- (void)fetchUserInboxWithCompletionHandler:(FacebookManagerRequestHandler)handler;
- (void)fetchUserUnRespondedFriendRequests:(FacebookManagerRequestHandler)handler;
- (void)fetchUserFriendProfile:(NSString *)uid handler:(FacebookManagerRequestHandler)handler;
@end
