//
//  BusinessListCell.h
//  MyGooi
//
//  Created by Vijayakumar on 06/10/14.
//  Copyright (c) 2014 Vijayakumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BusinessListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *logo;
@property (strong, nonatomic) IBOutlet UILabel *name;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property(nonatomic,retain)IBOutlet UILabel *gooi_lbl;
@property(nonatomic,retain)IBOutlet UILabel *ungooi_lbl;
@property(nonatomic,retain)IBOutlet UIButton *gooi_btn;
@property(nonatomic,retain)IBOutlet UIButton *ungooi_btn;
@property(nonatomic,retain)IBOutlet UIButton *comment_btn;
@end
