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
#import "ImageView.h"
#import "AnnotationCoordinateUtility.h"
#import "MapAnnotationView.h"

@interface FriendsMapViewController ()

@property (nonatomic, strong) Profile *myProfile;
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
    
    [_mapView setUserInteractionEnabled:YES];
    [self subscribeNotificaitons];
    [self setNavigationItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationItems {

    UIView *navTitleView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 40.0f)];
    
    if (self.myProfile) {
        ImageView *imgView = [[ImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 40.0f)];
        [imgView imageWithUri:self.myProfile.picUri];
        [imgView makeRoundedCorners];
        [navTitleView addSubview:imgView];
        
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setText:self.myProfile.name];
        [lbl sizeToFit];
        [lbl setFrame:CGRectMake(CGRectGetMinX(imgView.frame) + CGRectGetWidth(imgView.frame) + 5, CGRectGetMinY(imgView.frame), CGRectGetWidth(lbl.frame), CGRectGetHeight(imgView.frame))];
        
        [navTitleView addSubview:lbl];
        
        self.navigationItem.titleView = navTitleView;
    }//if

    
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
        [self fectchMyProfile];
        [self fetchFriends];
    }
}

- (void)fetchFriends {

    [[FacebookManager sharedManager] fetchFreindsLocationWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        PaserHandler *parserHandler = [[PaserHandler alloc] init];
        NSArray *friends = [parserHandler parseFriends:result];
        [self markFriendsOnMap:friends];
    }];
}

- (void)fectchMyProfile {

    [[FacebookManager sharedManager] fetchMyProfile:^(FBRequestConnection *connection, id result, NSError *error) {
        PaserHandler *parserHandler = [[PaserHandler alloc] init];
        self.myProfile = [parserHandler parseMyProfile:result];
        [self setNavigationItems];
    }];
}

- (void)markFriendsOnMap:(NSArray *)friends {
    
    NSMutableArray *annotations = [NSMutableArray array];
    for (Profile *friend in friends) {
        if (friend.currentLocationInfo) {
            MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithProfile:friend];
            [annotations addObject:newAnnotation];
            
        }//if
    }//for
    [AnnotationCoordinateUtility mutateCoordinatesOfClashingAnnotations:annotations];
    [_mapView addAnnotations:annotations];
    [self zoomToFitMapAnnotations:_mapView];

}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewID = @"annotationViewID";
    
    MapAnnotationView *annotationView = (MapAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
    }

    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        MapViewAnnotation *mapAnnotation = (MapViewAnnotation *)annotation;
        [annotationView setImageWithUri:mapAnnotation.profile.picUri];
        [annotationView setCanShowCallout:YES];
        annotationView.annotation = annotation;
    }

    
    return annotationView;
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
