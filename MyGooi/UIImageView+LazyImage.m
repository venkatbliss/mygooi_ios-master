//
//  UIImageView+LazyImage.m
//  LazyLoading
//
//  Created by Shivam Dotsquares on 20/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIImageView+LazyImage.h"

@implementation UIImageView (LazyImage)
-(void)setImageWithUrl:(NSURL *)url{
    [self setImageWithUrl:url andPlaceHoder:nil];
}
-(void)setImageWithUrl:(NSURL *)url andPlaceHoder:(UIImage*)placeHolderImage{
    [self setImageWithUrl:url andPlaceHoder:placeHolderImage andNoImage:nil];
}


-(void)setImageWithUrl:(NSURL *)url andPlaceHoder:(UIImage*)placeHolderImage andNoImage:(UIImage*)noImage{
    if (placeHolderImage==nil) {
       // if (isIPhone)
             placeHolderImage=[UIImage imageNamed:@"iphone_profile.png"];
      //  else
         //   placeHolderImage=[UIImage imageNamed:@"iPad_profile_pic.png"];
        
       
    }
    if (noImage==nil) {
        noImage=[UIImage imageNamed:@"noimage"];
    }
    [self setImage:placeHolderImage];
    
    NSOperationQueue *queue = [NSOperationQueue new];
    NSMutableDictionary *dic=[[NSMutableDictionary alloc] initWithObjectsAndKeys:url, @"url", noImage, @"noImage", nil];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] 
                                        initWithTarget:self
                                        selector:@selector(loadImage:) 
                                        object:dic];
    [queue addOperation:operation]; 
}
- (void)loadImage:(NSMutableDictionary*)dic {
    NSURL *url=[dic valueForKey:@"url"];
    UIImage* image=[CommonFunctions getCachedImage:url.relativeString];
    [self performSelectorOnMainThread:@selector(displayImage:) withObject:image waitUntilDone:NO];
}
- (void)displayImage:(UIImage *)image {
    self.alpha = 0.0f;
    [self setImage:image];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5f];
    self.alpha = 1.0f;
    [UIView commitAnimations];
    [self setNeedsDisplay];
    
}
@end
