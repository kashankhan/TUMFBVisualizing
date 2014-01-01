//
//  PaserHandler.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 13/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PaserHandler : NSObject

- (id)parseFriends:(id)object;
- (id)parseMyProfile:(id)object;
- (id)parseInboxInfo:(id)object;
- (id)parseFriendshipRequestsInfo:(id)object;
- (id)parseFriendshipRequestFriendInfo:(id)object;
@end
