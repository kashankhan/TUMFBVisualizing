//
//  BaseTableViewController.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 18/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewController : UITableViewController

- (void)setUpSubViews;
- (void)showProgressHud;
- (void)hideProgressHud;

@end
