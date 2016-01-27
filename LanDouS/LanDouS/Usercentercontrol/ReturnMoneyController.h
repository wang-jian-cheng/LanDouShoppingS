//
//  ReturnMoneyController.h
//  LanDouS
//
//  Created by Mao-MacPro on 15/1/25.
//  Copyright (c) 2015年 Mao-MacPro. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseNavigationController.h"
@interface ReturnMoneyController : BaseNavigationController<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableList;
    NSMutableArray *arrayList;
    NSString *storeid;
}
@property(nonatomic,copy)NSString *orderId;
@end
