//
//  ImageView.h
//  TUMFBVisualizing
//
//  Created by Kashan Khan on 14/11/2013.
//  Copyright (c) 2013 Kashan Khan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ImageViewDelegate;

@interface ImageView : UIImageView

- (void)imageWithUri:(NSString *)uri;
- (void)makeRoundedCorners;

@property (nonatomic, assign) id<ImageViewDelegate>delegate;
@end


@protocol ImageViewDelegate <NSObject>

@optional
- (void)imageViewDownloadDidStart:(ImageView *)image withUri:(NSString *)uri;
- (void)imageViewDownloadDidFinish:(ImageView *)image withImage:(UIImage *)image;
@end