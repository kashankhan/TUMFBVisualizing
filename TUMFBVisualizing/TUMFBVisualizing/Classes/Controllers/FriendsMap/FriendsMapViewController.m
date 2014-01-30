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
#import "NavigationBarView.h"
#import "MKMapView+Zoom.h"
#import "FriendDetailViewController.h"
#import "ProfileViewController.h"

@interface FriendsMapViewController ()

@property (nonatomic, strong) Profile *myProfile;
@property (nonatomic, weak) Profile *lastSelectedfriendProfile;
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
    [_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self subscribeNotificaitons];
    [self setNavigationItems];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationItems {


    if (self.myProfile) {
     
        self.navigationItem.titleView = [NavigationBarView navigationBarView:self.myProfile.picUri title:self.myProfile.name];
        
        UITapGestureRecognizer *gestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFacebookProfile)];
        [gestures setNumberOfTapsRequired:1];
        [self.navigationItem.titleView addGestureRecognizer:gestures];
     
        SEL selector =  NSSelectorFromString(@"openActionSheet:");
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:selector];
        [self.navigationItem setRightBarButtonItem:barItem];
    }
    else {
    
        self.navigationItem.titleView = nil;
        NSString *btnTitle = @"Login";
        SEL selector =  NSSelectorFromString(@"performLogin:");
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithTitle:btnTitle style:UIBarButtonItemStylePlain target:self action:selector];
        [self.navigationItem setRightBarButtonItem:barItem];
    }

    

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
    [_mapView removeAnnotations: [_mapView.annotations filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"!(self isKindOfClass: %@)", [MKUserLocation class]]]];
    
}

- (void)handleFacebookSessionHandleNotification:(NSNotification *)notification {

    BOOL userLogin = [[notification object] boolValue];
    
    [self setNavigationItems];
    
    if (userLogin) {
    
        [self fectchMyProfile];
        [self fetchFriends];
        [self fetchUserInbox];
    
    }//if
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
    [_mapView zoomToFitMapAnnotations];

}

- (void)fetchUserInbox {

    [[FacebookManager sharedManager] fetchUserInboxWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        PaserHandler *parserHandler = [[PaserHandler alloc] init];
        [parserHandler parseInboxInfo:result];
    }];
}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewID = @"annotationViewID";
    
    MapAnnotationView *annotationView = (MapAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
    }

    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    if ([annotation isKindOfClass:[MapViewAnnotation class]]) {
        MapViewAnnotation *mapAnnotation = (MapViewAnnotation *)annotation;
        [annotationView setImageWithUri:mapAnnotation.profile.picUri];
        [annotationView setProfile:mapAnnotation.profile];
        [annotationView setCanShowCallout:YES];
        [annotationView addTagetForDisclose:self action:@selector(openFriendDetailView:)];
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

- (void)openFriendDetailView:(Profile*)profile {

    self.lastSelectedfriendProfile = profile;
    [self performSegueWithIdentifier:@"SeguePushFriendDetailViewController" sender:self];
}

- (void)openFacebookProfile {
    
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [viewController setProfileId:self.myProfile.uid];
    [viewController setName:self.myProfile.name];
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"SeguePushFriendDetailViewController"]) {
        
        [[segue destinationViewController] setFriendProfile:self.lastSelectedfriendProfile];
        [[segue destinationViewController] setMyProfile:self.myProfile];
    }//if

}

#pragma mark -Action Sheet
- (void)openActionSheet:(id)sender {
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Friendship Requets",  @"Logout", nil];
    [actionSheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {

    switch (buttonIndex) {
        case 0:
            [self performSegueWithIdentifier:@"SegueFriendshipRequestsTableViewController" sender:self];
            break;
        case 1:
            [self performLogout:actionSheet];
            break;
            
        default:
            break;
    }
    if (buttonIndex == 0) {
        
    }
}

@end
