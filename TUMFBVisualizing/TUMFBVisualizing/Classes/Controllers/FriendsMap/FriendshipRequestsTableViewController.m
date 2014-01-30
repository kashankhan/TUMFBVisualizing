//
//  FriendshipRequestsTableViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 18/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "FriendshipRequestsTableViewController.h"
#import "PaserHandler.h"
#import "FriendRequest.h"
#import "Profile.h"
#import "FriendRequestTableViewCell.h"
#import "ProfileViewController.h"

@interface FriendshipRequestsTableViewController ()

@property (nonatomic, strong) NSMutableArray *items;
@end

@implementation FriendshipRequestsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubViews {
    
    [self setTitle:@"Friend Request"];
    
    self.items = [[NSMutableArray alloc] init];
    [self fetchUserUnRespondedFriends];
}
- (void)fetchUserUnRespondedFriends {

    [self showProgressHud];
    [[FacebookManager sharedManager] fetchUserUnRespondedFriendRequests:^(FBRequestConnection *connection, id result, NSError *error) {
        
        PaserHandler *parserHandler = [[PaserHandler alloc] init];
        NSArray *friendshipRequests = [parserHandler parseFriendshipRequestsInfo:result];
        
        for (FriendRequest *friendRequest in friendshipRequests) {
            
            [[FacebookManager sharedManager] fetchUserFriendProfile:friendRequest.uidFrom handler:^(FBRequestConnection *connection, id result, NSError *error) {
                
                PaserHandler *parserHandler = [[PaserHandler alloc] init];
                FriendRequest *friendRequest = [parserHandler parseFriendshipRequestFriendInfo:result];
                NSLog(@"friendRequest : %@", friendRequest);
                [self.items addObject:friendRequest];
                
                [self.tableView reloadData];
            }];
        }

        [self hideProgressHud];
    }];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return ([self.items count]) ? 1 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.items count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IdentifierFriendRequestTableViewCell";
    FriendRequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    FriendRequest *friendRequest = [self.items objectAtIndex:indexPath.row];
    Profile *profile = friendRequest.profileInfo;
    
    [cell.avatar imageWithUri:profile.picUri];
    [cell.friendNameLabel setText:profile.name];
    [cell.friendRequestDetialLabel setText:friendRequest.message];
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    FriendRequest *friendRequest = [self.items objectAtIndex:indexPath.row];
    Profile *profile = friendRequest.profileInfo;
    [self openFacebookProfile:profile];
}

- (void)openFacebookProfile:(Profile *)profile {

    ProfileViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileViewController"];
    [viewController setProfileId:profile.uid];
    [viewController setName:profile.name];
    [self.navigationController pushViewController:viewController animated:YES];

}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
