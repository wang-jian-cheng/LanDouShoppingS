//
//  ReturnmoneyCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/26.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReturnmoneyCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgGoods;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UILabel *lblPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsNum;
@property (strong, nonatomic) IBOutlet UIButton *btnReturnMoney;

@end
