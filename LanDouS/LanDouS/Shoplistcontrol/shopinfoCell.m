//
//  shopinfoCell.m
//  LanDouS
//
//  Created by Mao-MacPro on 14/12/26.
//  Copyright (c) 2014年 Mao-MacPro. All rights reserved.
//

#import "shopinfoCell.h"

@implementation shopinfoCell
@synthesize imageGood,lblTitle,lblNowPrice,lblOldPrice,lblBuyNum;
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageGood=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,90,90)];
        imageGood.image=[UIImage imageNamed:@"dq3.png"];
        [self.contentView addSubview:imageGood];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 40)];
        lblTitle.text =@"QQ";
        lblTitle.numberOfLines = 0;
        lblTitle.font = [UIFont systemFontOfSize:15];
        lblTitle.textColor = [UIColor blackColor];
        lblTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblTitle];
        
        lblNowPrice = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 60, 20)];
        lblNowPrice.text =@"￥20.10";
        lblNowPrice.numberOfLines = 0;
        lblNowPrice.font = [UIFont systemFontOfSize:14];
        lblNowPrice.textColor = [UIColor orangeColor];
        lblNowPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblNowPrice];
        
        lblOldPrice = [[LPLabel alloc] initWithFrame:CGRectMake(175, 55, 60, 20)];
        lblOldPrice.text =@"￥26.10";
        lblOldPrice.numberOfLines = 0;
        lblOldPrice.font = [UIFont systemFontOfSize:14];
        lblOldPrice.textColor = [UIColor grayColor];
        lblOldPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblOldPrice];
        
        lblBuyNum = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 160, 20)];
        lblBuyNum.text =@"11111人付款";
        lblBuyNum.numberOfLines = 0;
        lblBuyNum.font = [UIFont systemFontOfSize:12];
        lblBuyNum.textColor = [UIColor grayColor];
        lblBuyNum.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblBuyNum];
        
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
