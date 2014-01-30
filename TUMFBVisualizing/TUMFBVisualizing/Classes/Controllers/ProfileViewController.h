//
//  ProfileViewController.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 29/01/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "BaseViewController.h"

@interface ProfileViewController : BaseViewController <UIWebViewDelegate>

@property (nonatomic, assign) NSString *profileId;
@property (nonatomic, assign) NSString *name;

@end