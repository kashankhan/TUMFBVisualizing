//
//  FriendDetailViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 12/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "MapViewAnnotation.h"
#import "NavigationBarView.h"
#import "Profile.h"
#import "AnnotationCoordinateUtility.h"
#import "MapAnnotationView.h"
#import "MKMapView+Zoom.h"
#import "AppDAL.h"
#import "ProfileViewController.h"

@interface FriendDetailViewController ()

@end

static NSString *kCellTitleKey = @"CellTitle";
static NSString *kCellSubTitleKey = @"CellSubTitle";

@implementation FriendDetailViewController

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUpSubViews {
    
    [_mapView setUserInteractionEnabled:YES];
    //[_mapView setUserTrackingMode:MKUserTrackingModeFollow];
    [self markFriendOnMap];
    [self setNavigationItems];
    [self loadThreadInfo];
}

- (void)setNavigationItems {
    
    self.navigationItem.titleView = [NavigationBarView navigationBarView:self.friendProfile.picUri title:self.friendProfile.name];
    UITapGestureRecognizer *gestures = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openFacebookProfile)];
    [gestures setNumberOfTapsRequired:1];
    [self.navigationItem.titleView addGestureRecognizer:gestures];
}

- (void)markFriendOnMap {
    
    NSMutableArray *annotations = [NSMutableArray array];
    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc] initWithProfile:self.friendProfile];
    [annotations addObject:newAnnotation];
    [_mapView addAnnotations:annotations];
    
    MKMapRect zoomRect = MKMapRectNull;

    for (id <MKAnnotation> annotation in _mapView.annotations) {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        zoomRect = MKMapRectUnion(zoomRect, pointRect);
    }

}

- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    static NSString *annotationViewID = @"annotationViewID";
    
    MapAnnotationView *annotationView = (MapAnnotationView *)[theMapView dequeueReusableAnnotationViewWithIdentifier:annotationViewID];
    
    if (annotationView == nil) {
        annotationView = [[MapAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewID];
    }

    Profile *profile = ([annotation isKindOfClass:[MKUserLocation class]]) ? self.myProfile : self.friendProfile;
  
    [annotationView setImageWithUri:profile.picUri];
    [annotationView setProfile:profile];
    annotationView.annotation = annotation;

    return annotationView;
}

- (void)loadThreadInfo {

    _items = [[NSMutableArray alloc] init];
    AppDAL *appDAL = [[AppDAL alloc] init];
    NSArray *threads = [appDAL getAllThreadsBetweenProfiles:self.myProfile.uid person2:self.friendProfile.uid];
   
    long long msgCount = 0;
    for (Thread *thread in threads) {
        msgCount += [thread.messageCount longLongValue];
    }//for

    NSString *msgCountValue = [NSString stringWithFormat:@"%llu", msgCount];
    NSString *conversationsValue = [NSString stringWithFormat:@"%d", threads.count];

    NSDictionary *conversationsInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Total Conversatoins", kCellTitleKey , conversationsValue, kCellSubTitleKey, nil];
    [_items addObject:conversationsInfo];
    
    NSDictionary *msgCountInfo = [NSDictionary dictionaryWithObjectsAndKeys:@"Total Messages", kCellTitleKey , msgCountValue, kCellSubTitleKey, nil];
    [_items addObject:msgCountInfo];
    
    [_tableView reloadData];
    
}


- (void)openFacebookProfile {
    
    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [viewController setProfileId:self.friendProfile.uid];
    [self.navigationController pushViewController:viewController animated:YES];
    
}
#pragma mark -UITableView Datasource Methods
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return @"Conversations Info";
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_items count];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return ([_items count]) ? 1 : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IdentifierCell"];
    
    NSDictionary *itemInfo = [_items objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[itemInfo objectForKey:kCellTitleKey]];
    [cell.detailTextLabel setText:[itemInfo objectForKey:kCellSubTitleKey]];
    
    return cell;
}
@end
