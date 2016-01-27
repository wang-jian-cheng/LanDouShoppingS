//
//  ColGoodDetailCell.m
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/6.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import "ColGoodDetailCell.h"

@implementation ColGoodDetailCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 在此添加
        // 初始化时加载collectionCell.xib文件
        
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"ColGoodDetailCell" owner:self options: nil];
        // 如果路径不存在，return nil
        
        if(arrayOfViews.count < 1){
            return nil;
        }
        // 如果xib中view不属于UICollectionViewCell类，return nil
        if(![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]){
            
            return nil;
            
        }
        
        // 加载nib
        
        self = [arrayOfViews objectAtIndex:0];
        
        // Initialization code
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

@end
