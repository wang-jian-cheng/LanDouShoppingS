//
//  CellView.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/24.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "CellView.h"

@implementation CellView
@synthesize lblNum,lblPrice,lblgoodsName,imgGoods,btnGoodsDetail;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        imgGoods=[[UIImageView alloc]initWithFrame:CGRectMake(10, 10,80,80)];
        imgGoods.image=[UIImage imageNamed:@"dq3.png"];
        [self addSubview:imgGoods];
        
        btnGoodsDetail=[[UIButton alloc]initWithFrame:imgGoods.frame];
        [self addSubview:btnGoodsDetail];
        
        
        lblgoodsName = [[UILabel alloc] initWithFrame:CGRectMake(110, 10, 200, 40)];
        lblgoodsName.text =@"QQ";
        lblgoodsName.numberOfLines = 0;
        lblgoodsName.font = [UIFont systemFontOfSize:15];
        lblgoodsName.textColor = [UIColor blackColor];
        lblgoodsName.backgroundColor = [UIColor clearColor];
        [self addSubview:lblgoodsName];
        
        lblPrice = [[UILabel alloc] initWithFrame:CGRectMake(110, 55, 80, 20)];
        lblPrice.text =@"￥20.10";
        lblPrice.numberOfLines = 0;
        lblPrice.font = [UIFont systemFontOfSize:14];
        lblPrice.textColor = [UIColor orangeColor];
        lblPrice.backgroundColor = [UIColor clearColor];
        [self addSubview:lblPrice];
        
        lblNum = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-70, 55, 60, 20)];
        lblNum.text =@"￥20.10";
        lblNum.numberOfLines = 0;
        lblNum.textAlignment=NSTextAlignmentRight;
        lblNum.font = [UIFont systemFontOfSize:14];
        lblNum.textColor = [UIColor lightGrayColor];
        lblNum.backgroundColor = [UIColor clearColor];
        [self addSubview:lblNum];
        
        UIImageView *imageline1=[[UIImageView alloc]initWithFrame:CGRectMake(15, 100,SCREEN_WIDTH-30, 1)];
        //imageline1.image=[UIImage imageNamed:@"line_01.png"];
        imageline1.backgroundColor=[UIColor colorWithRed:0.95 green:0.95 blue:0.95 alpha:1];
        [self addSubview:imageline1];
        // Initialization code.
        //
        //[[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
        //[self addSubview:self.view];
    }
    return self;
}

//- (void) awakeFromNib
//{
//    [super awakeFromNib];
//    
//    [[NSBundle mainBundle] loadNibNamed:@"CellView" owner:self options:nil];
//    //[self addSubview:self.view];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
