//
//  BaseViewViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 11/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "BaseViewViewController.h"
#import "MBProgressHUD.h"

@interface BaseViewViewController ()

@property (nonatomic, strong) MBProgressHUD *progressHud;

@end

@implementation BaseViewViewController

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
    [self setUpSubViews];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpSubViews {


}
- (void)showProgressHud {
 
    self.progressHud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
	[self.navigationController.view addSubview:self.progressHud];
    [self.progressHud show:YES];
}

- (void)hideProgressHud {
    [self.progressHud hide:YES];
}
@end
