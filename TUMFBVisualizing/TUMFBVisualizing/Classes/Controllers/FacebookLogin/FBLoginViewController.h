//
//  FBLoginViewController.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 03/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewViewController.h"

@interface FBLoginViewController : BaseViewViewController <FBLoginViewDelegate>
@property (weak, nonatomic) IBOutlet FBLoginView *fbLoginView;

@end
