//
//  FriendRequestTableViewCell.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 18/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageView.h"

@interface FriendRequestTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet ImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *friendNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendRequestDetialLabel;

@end
