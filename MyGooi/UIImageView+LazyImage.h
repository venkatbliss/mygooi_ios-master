//
//  UIImageView+LazyImage.h
//  LazyLoading
//
//  Created by Shivam Dotsquares on 20/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonFunctions.h"

@interface UIImageView (LazyImage)
-(void)setImageWithUrl:(NSURL *)url;
-(void)setImageWithUrl:(NSURL *)url andPlaceHoder:(UIImage*)placeHolderImage;
-(void)setImageWithUrl:(NSURL *)url andPlaceHoder:(UIImage*)placeHolderImage andNoImage:(UIImage*)noImage;
- (void)displayImage:(UIImage *)image;
- (void)loadImage:(NSURL*)url;
@end
