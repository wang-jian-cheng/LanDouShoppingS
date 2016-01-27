//
//  WaitSendGoodsController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/16.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface WaitSendGoodsController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableWaitpay;
    NSMutableArray *arrayWaitpay;
    int page;
    int perpage;
    NSInteger rowID;
    NSInteger sectionID;
    
    float minTotalPrice;
    float onLinePayDiscount;
    
}
@property (strong, nonatomic) IBOutlet UIImageView *imgNoData;
@end
