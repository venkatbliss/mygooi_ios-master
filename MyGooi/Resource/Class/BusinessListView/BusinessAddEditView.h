//
//  BusinessAddEditView.h
//  MyGooi
//
//  Created by Vijayakumar on 07/10/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.


#import <UIKit/UIKit.h>

@interface BusinessAddEditView : UIViewController

@property (nonatomic) BOOL hasLocationData;

@property (retain, nonatomic) NSDictionary *dicLocationDetails;
- (IBAction)back:(id)sender;

@end
