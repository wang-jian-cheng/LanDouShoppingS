//
//  CellView.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CellView : UIView
@property (strong, nonatomic) UILabel *lblgoodsName;
@property (strong, nonatomic) UILabel *lblPrice;
@property (strong, nonatomic)  UILabel *lblNum;
@property (strong, nonatomic)  UIImageView *imgGoods;
@property (strong,nonatomic) UIButton *btnGoodsDetail;
@end
