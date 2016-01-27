//
//  ScoreListCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScoreListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgGoods;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblScore;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsNum;
@property (strong, nonatomic) IBOutlet UILabel *lblTotalScore;
@property (strong, nonatomic) IBOutlet UIButton *btnState;
@property (strong, nonatomic) IBOutlet UIButton *btnCancel;

@end
