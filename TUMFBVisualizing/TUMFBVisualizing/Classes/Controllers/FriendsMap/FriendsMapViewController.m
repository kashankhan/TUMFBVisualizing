//
//  FriendsMapViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FriendsMapViewController.h"
#import "PaserHandler.h"
#import "AppDAL.h"
#import "MapViewAnnotation.h"

@interface FriendsMapViewController ()

@end

@implementation FriendsMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (void)setUpSubViews {
    
    [_mapView setDelegate:self];
    [self subscribeNotificaitons];
    [self setNavigationItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationItems {

    NSString *btnTitle = [[FacebookManager sharedManager] isSessionActive] ? @"Logout" :  @"Login";
    SEL selector = ([[FacebookManager sharedManager] isSessionActive]) ? NSSelectorFromString(@"performLogout:") : NSSelectorFromString(@"performLogin:");
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:btnTitle style:UIBarButtonItemStylePlain target:self action:selector];
    [self.navigationItem setRightBarButtonItem:barItem];
}

- (void)subscribeNotificaitons {

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleFacebookSessionHandleNotification:) name:UIFacebookLUserSessionNotification object:nil];
}
- (void)performLogin:(id)sender {

   [[FacebookManager sharedManager] perfromLogin];
}

- (void)performLogout:(id)sender {
    
    [[FacebookManager sharedManager] logout];
    [self setNavigationItems];
    
}

- (void)handleFacebookSessionHandleNotification:(NSNotification *)notification {

    BOOL userLogin = [[notification object] boolValue];
    [self setNavigationItems];
    if (userLogin) {
        [self fetchFriends];
    }
}

- (void)fetchFriends{

    [[FacebookManager sharedManager] fecthFreindsLocationWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        PaserHandler *parserHandler = [[PaserHandler alloc] init];
        NSArray *friends = [parserHandler parseFriends:result];
        [self markFriendsOnMap:friends];
    }];
}

- (void)markFriendsOnMap:(NSArray *)friends {
    [friends enumerateObjectsUsingBlock:^(Friend *friend, NSUInteger idx, BOOL *stop) {
        
        CLLocationCoordinate2D location;
        if (friend.currentLocationInfo) {
            location.latitude = [friend.currentLocationInfo.latitude doubleValue];
            location.longitude = [friend.currentLocationInfo.longitude doubleValue];
            // Add the annotation to our map view
            MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithTitle:friend.name andCoordinate:location];
            [_mapView addAnnotation:newAnnotation];

        }
      
        [self zoomToFitMapAnnotations:_mapView];
    }];

}

// When a map annotation point is added, zoom to it (1500 range)
//- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
//{
//	MKAnnotationView *annotationView = [views objectAtIndex:0];
//	id <MKAnnotation> mp = [annotationView annotation];
//	MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance([mp coordinate], 1500, 1500);
//	[mv setRegion:region animated:YES];
//	[mv selectAnnotation:mp animated:YES];
//}

- (void)zoomToFitMapAnnotations:(MKMapView *)mapView {
    if ([mapView.annotations count] == 0) return;
    
    CLLocationCoordinate2D topLeftCoord;
    topLeftCoord.latitude = -90;
    topLeftCoord.longitude = 180;
    
    CLLocationCoordinate2D bottomRightCoord;
    bottomRightCoord.latitude = 90;
    bottomRightCoord.longitude = -180;
    
    for(id<MKAnnotation> annotation in mapView.annotations) {
        topLeftCoord.longitude = fmin(topLeftCoord.longitude, annotation.coordinate.longitude);
        topLeftCoord.latitude = fmax(topLeftCoord.latitude, annotation.coordinate.latitude);
        bottomRightCoord.longitude = fmax(bottomRightCoord.longitude, annotation.coordinate.longitude);
        bottomRightCoord.latitude = fmin(bottomRightCoord.latitude, annotation.coordinate.latitude);
    }
    
    MKCoordinateRegion region;
    region.center.latitude = topLeftCoord.latitude - (topLeftCoord.latitude - bottomRightCoord.latitude) * 0.5;
    region.center.longitude = topLeftCoord.longitude + (bottomRightCoord.longitude - topLeftCoord.longitude) * 0.5;
    region.span.latitudeDelta = fabs(topLeftCoord.latitude - bottomRightCoord.latitude) * 1.1;
    
    // Add a little extra space on the sides
    region.span.longitudeDelta = fabs(bottomRightCoord.longitude - topLeftCoord.longitude) * 1.1;
    
    region = [mapView regionThatFits:region];
    [mapView setRegion:region animated:YES];
}
@end
