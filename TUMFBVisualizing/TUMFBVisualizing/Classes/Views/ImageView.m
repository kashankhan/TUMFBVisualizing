//
//  ImageView.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 14/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "ImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ImageView

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
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

- (void)makeRoundedCorners {
    self.layer.cornerRadius = CGRectGetHeight(self.frame)/2;
    self.clipsToBounds = YES;
}

- (void)imageWithUri:(NSString *)uri {
    
    if ([self.delegate respondsToSelector:@selector(imageViewDownloadDidStart:withUri:)]) {
        [self.delegate imageViewDownloadDidStart:self withUri:uri];
    }
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc]
                                        initWithTarget:self
                                        selector:@selector(loadImageWithUri:)
                                        object:uri];
    [queue addOperation:operation];

}

- (void)loadImageWithUri:(NSString *)uri {
    
    NSData* imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:uri]];
    UIImage* image = [[UIImage alloc] initWithData:imageData];
  
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}

- (void)displayImage:(UIImage *)image {
    [self setImage:image];
    
    
    if ([self.delegate respondsToSelector:@selector(imageViewDownloadDidFinish:withImage:)]) {
        [self.delegate imageViewDownloadDidFinish:self withImage:image];
    }
}



@end
