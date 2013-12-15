//
//  NavigationBarView.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 12/12/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "NavigationBarView.h"
#import "ImageView.h"

@implementation NavigationBarView

+ (NavigationBarView *)navigationBarView:(NSString *)imgUri title:(NSString *)title {
    return  [[self alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 200.0f, 40.0f) imageUri:imgUri title:title];
    
}


- (id)initWithFrame:(CGRect)frame imageUri:(NSString *)imgUri title:(NSString *)title
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        ImageView *imgView = [[ImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 40, 40.0f)];
        [imgView imageWithUri:imgUri];
        [imgView makeRoundedCorners];
        [self addSubview:imgView];
        
        UILabel *lbl = [[UILabel alloc] init];
        [lbl setText:title];
        [lbl sizeToFit];
        [lbl setFrame:CGRectMake(CGRectGetMinX(imgView.frame) + CGRectGetWidth(imgView.frame) + 5, CGRectGetMinY(imgView.frame), CGRectGetWidth(lbl.frame), CGRectGetHeight(imgView.frame))];
        
        [self addSubview:lbl];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
