//
//  MyScoreCell.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/20.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyScoreCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgGoods;
@property (strong, nonatomic) IBOutlet UILabel *lblgoods;
@property (strong, nonatomic) IBOutlet UILabel *lblscore;
@property (strong, nonatomic) IBOutlet UILabel *lbldesc;
@property (strong, nonatomic) IBOutlet UIButton *btnExchange;

@end
