//
//  GoodListCell.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/5.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "GoodListCell.h"

@implementation GoodListCell
@synthesize imageGood,lblDisc,lblNowPrice,lblOldPrice,lblTitle,btnBuy;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        imageGood=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,90,90)];
        imageGood.image=[UIImage imageNamed:@"landou_square_default.png"];
        imageGood.contentMode=UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageGood];
        
        lblDisc = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 40)];
        lblDisc.text =@"QQ";
        lblDisc.numberOfLines = 0;
        lblDisc.font = [UIFont systemFontOfSize:15];
        lblDisc.textColor = [UIColor blackColor];
        lblDisc.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblDisc];
        
        lblNowPrice = [[UILabel alloc] initWithFrame:CGRectMake(110, 70,80, 20)];
        lblNowPrice.text =@"￥20.10";
        lblNowPrice.numberOfLines = 0;
        lblNowPrice.font = [UIFont systemFontOfSize:15];
        lblNowPrice.textColor = [UIColor orangeColor];
        lblNowPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblNowPrice];

        lblOldPrice = [[LPLabel alloc] initWithFrame:CGRectMake(195, 70, 80, 20)];
        lblOldPrice.text =@"￥26.10";
        lblOldPrice.numberOfLines = 0;
        lblOldPrice.strikeThroughColor=[UIColor grayColor];
        lblOldPrice.font = [UIFont systemFontOfSize:13];
        lblOldPrice.textColor = [UIColor grayColor];
        lblOldPrice.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:lblOldPrice];
        
        lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(110, 80, 160, 20)];
        lblTitle.text =@"结记水果";
        lblTitle.numberOfLines = 0;
        lblTitle.font = [UIFont systemFontOfSize:14];
        lblTitle.textColor = [UIColor grayColor];
        lblTitle.backgroundColor = [UIColor clearColor];
        lblTitle.hidden=YES;
        [self.contentView addSubview:lblTitle];
        
        btnBuy=[[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-40,70,30,30)];
        [btnBuy setImage:[UIImage imageNamed:@"shoppingCartIcon@2x.png"] forState:UIControlStateNormal];
        [btnBuy.layer setMasksToBounds:YES];
        btnBuy.layer.cornerRadius=2.0;
        [btnBuy setBackgroundColor:[UIColor colorWithRed:0.86 green:0.56 blue:0.15 alpha:1]];
        
        
        [self.contentView addSubview:btnBuy];
        
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
