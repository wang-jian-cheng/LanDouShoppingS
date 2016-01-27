//
//  ShopCartCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/12.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopCartCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *ImgGoods;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsName;
@property (strong, nonatomic) IBOutlet UIButton *btnCut;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd;
@property (strong, nonatomic) IBOutlet UITextField *textBuyNum;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblBuyNum;
@property (strong, nonatomic) IBOutlet UIImageView *imgbuyNumBG;
@property (strong, nonatomic) IBOutlet UIButton *btncheck;

@end
