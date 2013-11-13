//
//  FriendsMapViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FriendsMapViewController.h"
#import "PaserHandler.h"

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
        [[FacebookManager sharedManager] fecthFreindsLocationWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            PaserHandler *parserHandler = [[PaserHandler alloc] init];
            NSArray *friends = [parserHandler parseFriends:result];
            [self markFriendsOnMap:friends];
        }];
    }
}


- (void)markFriendsOnMap:(NSArray *)friends {



}
@end
