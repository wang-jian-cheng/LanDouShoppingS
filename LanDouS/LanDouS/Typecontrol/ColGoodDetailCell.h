//
//  ColGoodDetailCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/6.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ColGoodDetailCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgGood;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsDisc;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsPrice;
@property (strong, nonatomic) IBOutlet UILabel *lblGoodsBuyed;

@end
