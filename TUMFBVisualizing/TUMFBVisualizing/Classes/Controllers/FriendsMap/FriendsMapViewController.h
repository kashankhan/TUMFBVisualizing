//
//  FriendsMapViewController.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "BaseViewController.h"
#import <MapKit/MapKit.h>

@interface FriendsMapViewController : BaseViewController <MKMapViewDelegate, UIActionSheetDelegate> {

    __weak IBOutlet MKMapView *_mapView;
   
}

@end
