//
//  FriendDetailViewController.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 12/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@class Profile;

@interface FriendDetailViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate>{

    __weak IBOutlet MKMapView *_mapView;
    __weak IBOutlet UITableView *_tableView;
    NSMutableArray *_items;
}

@property (weak, nonatomic) Profile *friendProfile;
@property (weak, nonatomic) Profile *myProfile;
@end
