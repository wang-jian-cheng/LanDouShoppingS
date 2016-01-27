//
//  shopinfoCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/26.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPLabel.h"
@interface shopinfoCell : UITableViewCell
@property(nonatomic,strong)UIImageView *imageGood;
@property(nonatomic,strong)UILabel *lblTitle;
@property(nonatomic,strong)UILabel *lblNowPrice;
@property(nonatomic,strong)LPLabel *lblOldPrice;
@property(nonatomic,strong)UILabel *lblBuyNum;

@end
