//
//  MapAnnotationView.m
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 16/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import "MapAnnotationView.h"

@implementation MapAnnotationView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImageWithUri:(NSString *)uri {

    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:uri]];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = [self imageWithRoundedCornersRadius:20 withImage:image];
        });
    });
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (UIImage *) imageWithRoundedCornersRadius:(float) radius withImage:(UIImage *)image
{
    // Begin a new image that will be the new image with the rounded corners
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0);
    
    // Add a clip before drawing anything, in the shape of an rounded rect
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    [[UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius] addClip];
    
    // Draw your image
    [image drawInRect:rect];
    
    // Get the image, here setting the UIImageView image
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Lets forget about that we were drawing
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

@end
