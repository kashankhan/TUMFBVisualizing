//
//  ProfileViewController.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 29/01/2014.
//  Copyright (c) 2014 Kashan Khan. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@end

@implementation ProfileViewController

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
    
    [self showProgressHud];
    [self setTitle:self.name];
    
    NSString *uri = @"http://m.facebook.com/%@";
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:uri, self.profileId]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [self.webView setDelegate:self];
    [self.webView loadRequest:request];
}


- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [self hideProgressHud];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [self hideProgressHud];
}

@end
