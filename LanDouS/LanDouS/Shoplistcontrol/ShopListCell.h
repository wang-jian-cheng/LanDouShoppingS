//
//  ShopListCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/25.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopListCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblShopName;
@property (strong, nonatomic) IBOutlet UILabel *lblShopDisc;
@property (strong, nonatomic) IBOutlet UIImageView *imgShop;
@property (strong, nonatomic) IBOutlet UILabel *lblScore;

@end
