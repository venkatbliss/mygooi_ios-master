//
//  BusinessListView.h
//  MyGooi
//
//  Created by Vijayakumar on 06/10/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.
//com.mygooi.mygooisocialdev

#import <UIKit/UIKit.h>

@interface BusinessListView : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)addBusiness:(id)sender;
- (IBAction)goBack:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *backBtn;
@property(nonatomic,retain)IBOutlet UITableView *Business_table;
@property (nonatomic) BOOL LoadFromProfileView;


@end
