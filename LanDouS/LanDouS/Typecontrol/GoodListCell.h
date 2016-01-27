//
//  GoodListCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/5.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"
@interface GoodListCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imageGood;
@property(nonatomic,strong)UILabel *lblDisc;
@property(nonatomic,strong)UILabel *lblNowPrice;
@property(nonatomic,strong)LPLabel *lblOldPrice;
@property(nonatomic,strong)UILabel *lblTitle;
@property(nonatomic,strong)UIButton *btnBuy;
@end
