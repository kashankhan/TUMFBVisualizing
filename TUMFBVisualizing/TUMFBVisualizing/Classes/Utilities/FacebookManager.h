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
- (BOOL)openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication;
- (FBLoginView*)getFBLoginViewWithFrame:(CGRect)rect;
- (void)fecthFreindsWithCompletionHandler:(FacebookManagerRequestHandler)handler;;
- (void)fetchUserInboxWithCompletionHandler:(FacebookManagerRequestHandler)handler;

@end
