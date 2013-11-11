//
//  FBLoginViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 03/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FBLoginViewController.h"

@interface FBLoginViewController ()

@end

@implementation FBLoginViewController

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
    [self.view setBackgroundColor:[[UIColor darkGrayColor] colorWithAlphaComponent:0.5]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - FBLoginView delegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView {
    // if you become logged in, no longer flag to skip log in
    
//    [FBSession.activeSession requestNewReadPermissions:@[@"basic_info",@"user_likes", @"user_friends", @"friends_hometown", @"friends_location"]
//                                     completionHandler:^(FBSession *session,
//                                                         NSError *error)
//    {
        // Handle new permissions callback
        //[self fecthFreinds:0];
       // [self test];

//    }];
    

}

- (void)fecthFreinds {

    [FBRequestConnection startWithGraphPath:@"me/friends" parameters:[ NSDictionary dictionaryWithObjectsAndKeys:@"picture,id,name,link,gender,last_name,first_name, hometown,location",@"fields",nil] HTTPMethod:@"GET" completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        
        if(!error){
            NSLog(@"results = %@", [result valueForKey:@"data"]);
            //[self fecthFreinds:offset + [limit integerValue]];
            
        }
    }];
}

- (void)test  {

   NSString *query = @"SELECT uid, name, current_location.id, pic_square, current_location.latitude, current_location.longitude, current_location, current_location  FROM user WHERE uid IN (SELECT uid2 FROM friend WHERE uid1=me())";
    
    // Set up the query parameter
    NSDictionary *queryParam = @{ @"q": query };
    // Make the API request that uses FQL
    [FBRequestConnection startWithGraphPath:@"/fql"
                                 parameters:queryParam
                                 HTTPMethod:@"GET"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error) {
                              if (error) {
                                  NSLog(@"Error: %@", [error localizedDescription]);
                              } else {
                                  NSLog(@"Result: %@", result);
                              }
                          }];
}

- (void)test2 {

//    SELECT thread_id, message_count, recipients
//    FROM thread
//    WHERE folder_id=0
//    AND (originator IN (SELECT uid2 FROM friend WHERE uid1 = me()) OR originator=me())
//    AND updated_time < now() ORDER BY message_count DESC
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
//    // Facebook SDK * login flow *
//    // It is important to always handle session closure because it can happen
//    // externally; for example, if the current session's access token becomes
//    // invalid. For this sample, we simply pop back to the landing page.
//    SCAppDelegate *appDelegate = (SCAppDelegate *)[UIApplication sharedApplication].delegate;
//    if (appDelegate.isNavigatingAwayFromLogin) {
//        // The delay is for the edge case where a session is immediately closed after
//        // logging in and our navigation controller is still animating a push.
//        [self performSelector:@selector(logOut) withObject:nil afterDelay:.5];
//    } else {
//        [self logOut];
//    }
}

- (void)logOut {
    // on log out we reset the main view controller
//    SCAppDelegate *appDelegate = (SCAppDelegate *)[UIApplication sharedApplication].delegate;
//    [appDelegate resetMainViewController];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
